# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# backendset.tf
#
# Purpose: The following script contains the logic to create a backend set of an already provisioned LBAAS service
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_backend_set
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_path_route_set
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_listener
#           https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_backend


resource "oci_load_balancer_backend_set" "BackendSet" {
  name             = var.lbaas_bes_single_backend_set_name
  load_balancer_id = var.lbaas_bes_single_load_balancer_id
  policy           = var.lbaas_policy

  health_checker {
    port                = var.lbaas_bes_single_checkport
    protocol            = var.lbaas_bes_single_check_protocol
    response_body_regex = ".*"
    url_path            = "/"
  }
    session_persistence_configuration {
        cookie_name = var.lbaas_bes_single_session_persistance_cookie_name
    }
}


resource "oci_load_balancer_path_route_set" "PathToRouteSet" {
  load_balancer_id = var.lbaas_bes_single_load_balancer_id
  name             = var.lbaas_bes_single_path_to_routeset_name
  path_routes {
    backend_set_name = oci_load_balancer_backend_set.BackendSet.name
    path             = "/"
    path_match_type {
      match_type = "EXACT_MATCH"
    }
  }
}


resource "oci_load_balancer_hostname" "Balanced_Artifact" {  
  count            = length(var.lbaas_bes_single_balanced_artifact)
  hostname         = var.lbaas_bes_single_balanced_artifact[count.index].display_name
  load_balancer_id = var.lbaas_bes_single_load_balancer_id
  name             = var.lbaas_bes_single_balanced_artifact[count.index].display_name
}


resource "oci_load_balancer_listener" "LBaaSListener" {
  load_balancer_id         = var.lbaas_bes_single_load_balancer_id
  name                     = var.lbaas_bes_single_balancing_protocol
  port                     = var.lbaas_bes_single_listen_port
  protocol                 = var.lbaas_bes_single_listen_protocol
  default_backend_set_name = oci_load_balancer_backend_set.BackendSet.name

}


resource "oci_load_balancer_backend" "Backend" {  
  count            = length(var.lbaas_bes_single_balanced_artifact)
  load_balancer_id = var.lbaas_bes_single_load_balancer_id
  backendset_name  = oci_load_balancer_backend_set.BackendSet.name
  ip_address       = var.lbaas_bes_single_balanced_artifact[count.index].private_ip
  port             = var.lbaas_bes_single_checkport
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}