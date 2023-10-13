locals {
  #-----------------------------------------------------------------------------------------------------
  # Student general variables (NOT update)
  #-----------------------------------------------------------------------------------------------------
  # General
  prefix            = local.tags["Owner"]
  admin_port        = "8443"
  admin_cidr        = "0.0.0.0/0"
  fgt_instance_type = "c6i.large"
  fgt_build         = "build1517"
  license_type      = "payg"
  fgt_cidrhost      = "10"
  # HUB SDWAN
  hub = [{
    id                = "HUB"
    bgp_asn_hub       = "65000"
    bgp_asn_spoke     = "65000"
    vpn_cidr          = "10.10.20.0/24"
    vpn_psk           = local.externalid_token
    ike_version       = "2"
    network_id        = "1"
    dpd_retryinterval = "5"
    mode_cfg          = true
    vpn_port          = "public"
  }]
  # SPOKE SDWAN
  spoke = {
    id      = local.tags["Owner"]
    cidr    = local.student_vpc_cidr
    bgp-asn = local.hub[0]["bgp_asn_spoke"]
  }
  # SDWAN zones and config
  hubs = [for hub in local.hub :
    {
      id                = hub["id"]
      bgp_asn           = hub["bgp_asn_hub"]
      external_ip       = local.hub_fgt_pip
      hub_ip            = cidrhost(hub["vpn_cidr"], 1)
      site_ip           = ""
      hck_ip            = cidrhost(hub["vpn_cidr"], 1)
      vpn_psk           = hub["vpn_psk"]
      cidr              = hub["vpn_cidr"]
      ike_version       = hub["ike_version"]
      network_id        = hub["network_id"]
      dpd_retryinterval = hub["dpd_retryinterval"]
      sdwan_port        = hub["vpn_port"]
    }
  ]
  #--------------------------------------------------------------------------------------------
  # Student server
  #--------------------------------------------------------------------------------------------
  srv_instance_type    = "t3.small"
  docker_image         = "swaggerapi/petstore"
  docker_port_internal = "8080"
  lab_dns_name         = "xpertsummit-es.com"
}

#--------------------------------------------------------------------------
# Write AWS CLI credentials in Cloud9 instance
#--------------------------------------------------------------------------
resource "local_file" "aws_cli_credentials" {
  content         = <<-EOT
    [default]
    aws_access_key_id = ${var.access_key}
    aws_secret_access_key = ${var.secret_key}
    aws_session_token = 
  EOT
  filename        = "/home/ec2-user/.aws/credentials"
  file_permission = "0600"
}

#--------------------------------------------------------------------------
# Necessary variables if not provided
#--------------------------------------------------------------------------
# Create key-pair
resource "aws_key_pair" "keypair" {
  key_name   = "${local.prefix}-keypair-${trimspace(random_string.keypair.result)}"
  public_key = tls_private_key.ssh.public_key_openssh
}
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "local_file" "ssh_private_key_pem" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "./ssh-key/${local.prefix}-ssh-key.pem"
  file_permission = "0600"
}
// Create random string for api_key name
resource "random_string" "keypair" {
  length  = 5
  special = false
  numeric = false
}