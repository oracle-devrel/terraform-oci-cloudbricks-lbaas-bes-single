# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# output.tf
#
# Purpose: The following script defines the output for LBaaS backendset Creation


output "application_bes_instance" {
  value = oci_load_balancer_backend_set.ApplicationBackendSet
}

output "network_bes_instance" {
  value = oci_network_load_balancer_backend_set.NetworkBackendSet
}

output "instancepool_bes_instance" {
  value = oci_load_balancer_backend_set.InstancePoolBackendSet
}
