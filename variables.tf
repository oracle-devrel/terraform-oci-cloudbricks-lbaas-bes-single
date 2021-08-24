# Copyright (c) 2021 Oracle and/or its affiliates.
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# variables.tf 
#
# Purpose: The following file declares all variables used in this backend repository



/********** Provider Variables NOT OVERLOADABLE **********/
variable "region" {
  description = "Target region where artifacts are going to be created"
}

variable "tenancy_ocid" {
  description = "OCID of tenancy"
}

variable "user_ocid" {
  description = "User OCID in tenancy. Currently hardcoded to user denny.alquinta@oracle.com"
}

variable "fingerprint" {
  description = "API Key Fingerprint for user_ocid derived from public API Key imported in OCI User config"
}

variable "private_key_path" {
  description = "Private Key Absolute path location where terraform is executed"

}
/********** Provider Variables NOT OVERLOADABLE **********/



/********** LBaaS Single Backend Set Variables **********/
variable "lbaas_bes_single_instance_compartment_name" {
  description = "LBaaS Backend Set Artifact Compartment Location"
}

variable "lbaas_bes_single_network_compartment_name" {
  description = "LBaaS Backend Set Network Compartment Location"
}

variable "lbaas_bes_single_backend_set_name" {
  description = "LBaaS Backend Set Name to be provided on provisioning time"
}

variable "lbaas_bes_single_load_balancer_id" {
  description = "Modular integration for receiving an already created Load balancer. Use the LBAAS service created on separate module and pass on through it"
}

variable "lbaas_policy" {
  description = "Load balancing policy chosen"
  default     = "ROUND_ROBIN"
}

variable "lbaas_bes_single_checkport" {
  description = "Port where the healthcheck will be performed"
}

variable "lbaas_bes_single_check_protocol" {
  description = "Protocol to be used on healthcheck"
}

variable "lbaas_bes_single_path_to_routeset_name" {
  description = "Specific path where redirection will occur"
}

variable "lbaas_bes_single_balanced_artifact" {
  description = "Integration variable which encapsulates any generic resource that may be balanced by this LBaaS"
}

variable "lbaas_bes_single_balancing_protocol" {
  description = "Protocol in which balancing will occur. This may be http or tcp"
}

variable "lbaas_bes_single_session_persistance_cookie_name" {
  description = "Name of the cookie related to maintain session persistance for balanced application"
}

variable "lbaas_bes_single_listen_port" {
  description = "Port where listener will receive communication"
  
}

variable "lbaas_bes_single_listen_protocol" {
  description = "Protocol where Listener will receive communication"
  
}
/********** LBaaS Single Backend Set Variables **********/



/********** Datasource and Subnet Lookup related variables **********/

variable "lbaas_bes_single_network_subnet_name" {
  description = "Defines the subnet display name where this resource will be created at"
}

variable "lbaas_bes_single_vcn_display_name" {
  description = "VCN Display name to execute lookup"
}

/********** Datasource related variables **********/