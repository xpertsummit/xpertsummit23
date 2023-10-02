#--------------------------------------------------------------------------------------------
# Create student-X server LAB (NOT UPDATE)
#--------------------------------------------------------------------------------------------
# Create NI for server
resource "aws_network_interface" "student_server" {
  subnet_id         = module.student_vpc.subnet_ids["bastion"]
  security_groups   = [module.student_vpc.sg_ids["bastion"]]
  private_ips       = [cidrhost(module.student_vpc.subnet_cidrs["bastion"], 10)] // "x.x.x.202"
  source_dest_check = false
  tags = {
    Name = "${local.prefix}-student-0-server"
  }
}
# Create EIP active public NI for server test
resource "aws_eip" "student_server" {
  domain            = "vpc"
  network_interface = aws_network_interface.student_server.id
  tags = {
    Name = "${local.prefix}-student-0-server"
  }
}
# Deploy cluster master node
module "student_server" {
  depends_on = [module.student_fgt]
  source     = "git::github.com/jmvigueras/modules//aws/new-instance_ni"

  prefix  = "${local.prefix}-stdent-0-server"
  keypair = aws_key_pair.keypair.key_name

  instance_type = local.srv_instance_type
  linux_os      = "amazon"
  user_data     = data.template_file.student_server_user_data.rendered

  ni_id = aws_network_interface.student_server.id
}
# Generate template file
data "template_file" "student_server_user_data" {
  template = file("./templates/student_user-data.tpl")
  vars = {
    docker_image         = local.docker_image
    docker_port_internal = local.docker_port_internal
    docker_port_external = "80"
    docker_env           = "-e SWAGGER_HOST=http://${aws_eip.student_server.public_ip} -e SWAGGER_BASE_PATH=/v2 -e SWAGGER_URL=http://${aws_eip.student_server.public_ip}"
  }
}