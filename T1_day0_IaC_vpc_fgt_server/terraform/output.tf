output "student_fgt" {
  value = {
    mgmt_url   = "https://${module.student_fgt.fgt_eip_mgmt}:${local.admin_port}"
    username   = "admin"
    password   = module.student_fgt.fgt_id
    mgmt_ip    = module.student_fgt.fgt_eip_mgmt
    public_ip  = module.student_fgt.fgt_eip_public
    private_ip = module.student_fgt.fgt_ni_ips["public"]
    admin_cidr = local.admin_cidr
    admin_port = local.admin_port
    api_key    = local.externalid_token
  }
}

output "student_server" {
  value = {
    private_ip = module.student_server.vm["private_ip"]
    public_ip  = module.student_server.vm["public_ip"]
    portal_uri = "http://${module.student_server.vm["public_ip"]}"
    app_port   = "80"
  }
}