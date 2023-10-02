##############################################################################################################
# Configure provider FortiOS
##############################################################################################################
terraform {
  required_providers {
    fortios = {
      source = "fortinetdev/fortios"
    }
  }
}
##############################################################################################################
# - NOT CHANGE - 
# Update variable tags in vars.tf and access_key & secret_key in terraform.tfvars
##############################################################################################################
provider "fortios" {
  hostname = "${local.student_fgt["mgmt_ip"]}:${local.student_fgt["admin_port"]}"
  token    = local.student_fgt["api_key"]
  insecure = "true"
}