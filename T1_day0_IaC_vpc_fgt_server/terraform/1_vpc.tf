#------------------------------------------------------------------------------
# Deploy student VPC (NOT UPDATE)
#------------------------------------------------------------------------------

# Call VPC module with necessary variables 
#
# - region   : region where deploy
# - tags     : tags asigned to resources
# - vpc_cidr : VPC cidr range
#
module "student_vpc" {
  source = "./modules/fgt_vpc_1az"

  region = local.region
  tags   = local.tags

  vpc_cidr = local.student_vpc_cidr
}