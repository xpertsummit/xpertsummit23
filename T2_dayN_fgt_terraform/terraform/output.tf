output "app_fgt_access" {
  value = { 
    url       = "http://${local.student_fgt["public_ip"]}:${local.student_server["app_port"]}"
    public_ip = local.student_fgt["public_ip"]
  }
}