locals {
  #-----------------------------------------------------------------------------------------------------
  # IMPORTANT: UPDATE variables with data provided in course
  #-----------------------------------------------------------------------------------------------------

  # Tags UPDATE Owner with your AWS IAM user name
  tags = {
    Owner   = "xs23-eu-west-1-user-1" //update with your assigned user for access AWS console
    Name    = "user-1"                //update with your assigned user for access AWS console
    Project = "xs23"
  }

  # Region and Availability Zone where deploy VPC and Subnets
  region = {
    "id"  = "eu-west-1"  //update with your assigned region
    "az1" = "eu-west-1a" //update with your assigned AZ
  }

  # CIDR range to use for your VCP: 10.1.x.x group 1 - 10.1.1.0/24 user-1
  student_vpc_cidr = "10.10.10.0/24"

  # HUB SDWAN fortigate details
  hub_fgt_pip      = "34.35.36.37"        //update with data showed in lab web
  externalid_token = "lab_token_provided" //update with lab token (this will be the VPN PSK)

  # AWS account_id
  account_id = "042579xxxxx"
}




