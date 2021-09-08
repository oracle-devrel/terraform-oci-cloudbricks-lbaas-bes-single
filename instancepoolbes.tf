# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# instancepoolbes.tf
#
# Purpose: The following script contains the logic to create an instance pool backend set of an already provisioned application LBaaS service
# Registry: https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/load_balancer_backend_set


resource "oci_load_balancer_backend_set" "InstancePoolBackendSet" {
  count            = var.is_instancepool_bes ? 1 : 0
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
