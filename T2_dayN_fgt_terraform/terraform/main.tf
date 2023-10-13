##############################################################################################################
# - NOT CHANGE - 
# (This variables can remain by default - imported from T1)
##############################################################################################################
# Read data from deployment T1_day0
data "terraform_remote_state" "T1_day0" {
  backend = "local"
  config = {
    path = "../../T1_day0_IaC_vpc_fgt_server/terraform/terraform.tfstate"
  }
}
# Locals data from T1_day0
locals {
  // Create locals from T1_day0 trainnnig terraform output
  student_fgt    = data.terraform_remote_state.T1_day0.outputs.student_fgt
  student_server = data.terraform_remote_state.T1_day0.outputs.student_server
}


