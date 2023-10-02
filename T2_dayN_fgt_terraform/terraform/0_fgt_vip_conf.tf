# ------------------------------------------------------------------------------------------
#  Define a new VIP resource
# ------------------------------------------------------------------------------------------
resource "fortios_firewall_vip" "app_vip" {
  name = "vip-${local.student_fgt["private_ip"]}-${local.student_server["app_port"]}"

  type        = "static-nat"
  extintf     = "port1"
  extip       = local.student_fgt["private_ip"]
  extport     = "80"
  mappedport  = "80"
  portforward = "enable"

  mappedip {
    range = local.student_server["private_ip"]
  }
}
# Define a new firewall policy with default intrusion prevention profile
resource "fortios_firewall_policy" "app_policy" {
  depends_on = [fortios_firewall_vip.aws_app_vip]

  name = "vip-${local.student_fgt["private_ip"]}-${local.student_server["app_port"]}"

  schedule        = "always"
  action          = "accept"
  utm_status      = "enable"
  ips_sensor      = "all_default_pass"
  ssl_ssh_profile = "certificate-inspection"
  nat             = "enable"
  logtraffic      = "all"

  dstintf {
    name = "port2"
  }
  srcintf {
    name = "port1"
  }
  srcaddr {
    name = "all"
  }
  dstaddr {
    name = "vip-${local.student_fgt["private_ip"]}-${local.student_server["app_port"]}"
  }
  service {
    name = "ALL"
  }
}
