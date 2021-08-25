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

variable "backend_set_name" {
  description = "LBaaS Backend Set Name to be provided on provisioning time"
}

variable "is_app_bes" {
  description = "Boolean that determines if an application backend set should be provisioned or not"
  default     = false
  type        = bool
}

variable "is_network_bes" {
  description = "Boolean that determines if a network backend set should be provisioned or not"
  default     = false
  type        = bool
}

variable "is_instancepool_bes" {
  description = "Boolean that determines if an instancepool backend set should be provisioned or not"
  default     = false
  type        = bool
}

variable "load_balancer_id" {
  description = "Modular integration for receiving an already created Load balancer. Use the LBAAS service created on separate module and pass on through it"
}

variable "lbaas_policy" {
  description = "Load balancing policy chosen"
}

variable "backend_set_is_preserve_source" {
  description = "If this optional parameter is enabled, then the network load balancer preserves the source IP of the packet when it is forwarded to backends. Backends see the original source IP. If the isPreserveSourceDestination parameter is enabled for the network load balancer resource, then this parameter cannot be disabled. The value is true by default."
  default     = false
  type        = bool
}

variable "checkport" {
  description = "Port where the healthcheck will be performed"
}

variable "check_protocol" {
  description = "Protocol to be used on healthcheck"
}

variable "balanced_artifact" {
  description = "Integration variable which encapsulates any generic resource that may be balanced by this LBaaS"
  default     = ""
}

variable "listener_name" {
  description = "Name of the listener attached to the backend LBaaS and points to backends"
  default     = ""
}

variable "session_persistance_cookie_name" {
  description = "Name of the cookie related to maintain session persistance for balanced application"
  default     = ""
}

variable "listen_port" {
  description = "Port where listener will receive communication"
  default     = ""
}

variable "listen_protocol" {
  description = "Protocol where Listener will receive communication"
  default     = ""
}


variable "routing_policy_condition_language_version" {
  description = "Version used to parse routing policy language"
  default     = ""
}

variable "routing_policy_name" {
  description = "Routing Policy name to be provided when provisioning"
  default     = ""
}

variable "routing_policy_conditions" {
  description = "Map of routing policy rule names to routing policy conditions"
  default     = ""
}

variable "routing_policy_actions_name" {
  description = "Actions to take place when conditons are met"
  default     = ""
}

variable "lbaas_cert_is_path" {
  description = "Describes if LbaaS certificate is located on file or inside code"
  default     = true
}

variable "lbaas_pvt_key_is_path" {
  description = "Describes if LbaaS certificate private key is located on file or inside code"
  default     = true
}

variable "lbaas_pub_cert_is_path" {
  description = "Describes if LbaaS public certificate is located on file or inside code"
  default     = true
}

variable "lbaas_ca_cert" {
  description = "The Certificate Authority certificate, or any interim certificate, that you received from your SSL certificate provider."
  default     = ""
}

variable "lbaas_public_cert" {
  description = "The SSL public certificate, in PEM format."
  default     = ""
}

variable "certificate_passphrase" {
  description = "A passphrase for encrypted private keys. This is needed only if you created your certificate with a passphrase."
  default     = ""
}

variable "certificate_private_key" {
  description = "The SSL private key for your certificate, in PEM format."
  default     = ""
}

variable "certificate_name" {
  description = "A friendly name for the certificate bundle. It must be unique and it cannot be changed. Valid certificate bundle names include only alphanumeric characters, dashes, and underscores. Certificate bundle names cannot contain spaces. Avoid entering confidential information."
  default     = ""
}

variable "verify_peer_certificate" {
  description = "Whether the load balancer listener should verify peer certificates"
  default     = false
}

/********** LBaaS Single Backend Set Variables **********/



/********** Datasource and Subnet Lookup related variables **********/

variable "network_subnet_name" {
  description = "Defines the subnet display name where this resource will be created at"
}

variable "vcn_display_name" {
  description = "VCN Display name to execute lookup"
}

/********** Datasource related variables **********/
