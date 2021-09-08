# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# appbes.tf
#
# Purpose: The following script contains the logic to create an application backend set of an already provisioned application LBaaS service
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_backend_set
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_load_balancer_routing_policy
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_hostname
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_listener
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_backend


resource "oci_load_balancer_backend_set" "ApplicationBackendSet" {
  count            = var.is_app_bes ? 1 : 0
  name             = var.backend_set_name
  load_balancer_id = var.load_balancer_id
  policy           = var.lbaas_policy

  health_checker {
    port                = var.checkport
    protocol            = var.check_protocol
    response_body_regex = ".*"
    url_path            = "/"
  }
  session_persistence_configuration {
    cookie_name = var.session_persistance_cookie_name
  }
}

resource "oci_load_balancer_load_balancer_routing_policy" "ApplicationRoutingPolicy" {
  depends_on = [oci_load_balancer_backend_set.ApplicationBackendSet]

  count                      = var.is_app_bes && var.routing_policy_name != "" ? 1 : 0
  condition_language_version = var.routing_policy_condition_language_version
  load_balancer_id           = var.load_balancer_id
  name                       = var.routing_policy_name

  dynamic "rules" {
    for_each = var.routing_policy_conditions
    content {
      condition = rules.value
      name      = rules.key
      actions {
        name = var.routing_policy_actions_name

        backend_set_name = oci_load_balancer_backend_set.ApplicationBackendSet[0].name
      }
    }
  }
}


resource "oci_load_balancer_hostname" "ApplicationBalanced_Artifact" {
  count            = var.listen_protocol != "TCP" && var.is_app_bes ? length(var.balanced_artifact) : 0
  hostname         = var.balanced_artifact[count.index].display_name
  load_balancer_id = var.load_balancer_id
  name             = var.balanced_artifact[count.index].display_name
}


resource "oci_load_balancer_certificate" "ApplicationLoadBalancerCertificate" {
  count            = var.is_app_bes && var.listen_port == "443" ? 1 : 0
  certificate_name = var.certificate_name
  load_balancer_id = var.load_balancer_id

  ca_certificate     = var.lbaas_cert_is_path ? file(var.lbaas_ca_cert) : var.lbaas_ca_cert
  passphrase         = var.certificate_passphrase
  private_key        = var.lbaas_pvt_key_is_path ? file(var.certificate_private_key) : var.certificate_private_key
  public_certificate = var.lbaas_pub_cert_is_path ? file(var.lbaas_public_cert) : var.lbaas_public_cert

  lifecycle {
    create_before_destroy = true
  }
}


resource "oci_load_balancer_listener" "ApplicationLBaaSListener" {
  depends_on = [
    oci_load_balancer_load_balancer_routing_policy.ApplicationRoutingPolicy,
    oci_load_balancer_certificate.ApplicationLoadBalancerCertificate
  ]

  count            = var.is_app_bes ? 1 : 0
  load_balancer_id = var.load_balancer_id
  name             = var.listener_name
  port             = var.listen_port
  protocol         = var.listen_protocol

  default_backend_set_name = oci_load_balancer_backend_set.ApplicationBackendSet[0].name
  routing_policy_name      = oci_load_balancer_load_balancer_routing_policy.ApplicationRoutingPolicy.*.name == [] ? null : oci_load_balancer_load_balancer_routing_policy.ApplicationRoutingPolicy[0].name
  hostname_names           = oci_load_balancer_hostname.ApplicationBalanced_Artifact.*.name

  dynamic "ssl_configuration" {
    for_each = var.listen_port == "443" ? [1] : []
    content {
      certificate_name        = oci_load_balancer_certificate.ApplicationLoadBalancerCertificate[0].certificate_name
      verify_peer_certificate = var.verify_peer_certificate
      cipher_suite_name       = var.listen_protocol == "HTTP2" ? "oci-default-http2-ssl-cipher-suite-v1" : ""
    }
  }
}


resource "oci_load_balancer_backend" "ApplicationBackend" {
  depends_on = [oci_load_balancer_backend_set.ApplicationBackendSet]

  count            = var.is_app_bes ? length(var.balanced_artifact) : 0
  load_balancer_id = var.load_balancer_id
  backendset_name  = oci_load_balancer_backend_set.ApplicationBackendSet[0].name

  ip_address = var.balanced_artifact[count.index].private_ip
  port       = var.backend_port
  backup     = false
  drain      = false
  offline    = false
  weight     = 1
}
