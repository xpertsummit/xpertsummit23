output "app_fgt_access" {
  value = "http://${local.student_fgt["public_ip"]}:${local.student_fgt["app_port"]}}"
}