locals {
  # ----------------------------------------------------------------------------------
  # FGT IP
  # ----------------------------------------------------------------------------------
  # Prefix 
  prefix = var.tags["Name"]
  # Generate map of IPs for each subnet
  fgt_ni_ips = {
    for ni in var.fgt_ni_index :
    ni => cidrhost(var.subnet_cidrs[ni], var.fgt_cidrhost)
  }
  # Generate map of IDs of each NI
  fgt_ni_ids = {
    for idx, ni in var.fgt_ni_index :
    ni => aws_network_interface.fgt_nis[idx].id
  }
}