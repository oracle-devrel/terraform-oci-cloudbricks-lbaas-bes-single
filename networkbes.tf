# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# networkbes.tf
#
# Purpose: The following script contains the logic to create a network backend set of an already provisioned network LBaaS service
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/network_load_balancer_backend_set
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/network_load_balancer_listener
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/network_load_balancer_backend

resource "oci_network_load_balancer_backend_set" "NetworkBackendSet" {
  count                    = var.is_network_bes ? 1 : 0
  name                     = var.backend_set_name
  network_load_balancer_id = var.load_balancer_id
  policy                   = var.lbaas_policy

  health_checker {
    port                = var.checkport
    protocol            = var.check_protocol
    response_body_regex = ".*"
    url_path            = "/"
  }

  is_preserve_source = var.backend_set_is_preserve_source
}


resource "oci_network_load_balancer_listener" "NetworkLBaaSListener" {
  depends_on = [oci_network_load_balancer_backend_set.NetworkBackendSet]

  count                    = var.is_network_bes ? 1 : 0
  network_load_balancer_id = var.load_balancer_id
  name                     = var.listener_name
  port                     = var.listen_port
  protocol                 = var.listen_protocol
  default_backend_set_name = oci_network_load_balancer_backend_set.NetworkBackendSet[0].name
}


resource "oci_network_load_balancer_backend" "NetworkBackend" {
  depends_on = [oci_network_load_balancer_backend_set.NetworkBackendSet]

  count                    = var.is_network_bes ? length(var.balanced_artifact) : 0
  network_load_balancer_id = var.load_balancer_id
  backend_set_name          = oci_network_load_balancer_backend_set.NetworkBackendSet[0].name

  ip_address = var.balanced_artifact[count.index].private_ip
  port       = var.checkport
  is_backup  = false
  is_drain   = false
  is_offline = false
  weight     = 1
}
