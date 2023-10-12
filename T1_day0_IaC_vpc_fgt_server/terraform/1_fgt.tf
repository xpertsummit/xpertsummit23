#------------------------------------------------------------------------------
# Deploy student FGT (NOT UPDATE)
#------------------------------------------------------------------------------
# Call ftg_config module with necessary variables to generate FGT config
module "student_fgt_config" {
  source = "./modules/fgt_config"

  api_key           = local.externalid_token          //API key will be the external token provided in the lab
  subnet_cidrs      = module.student_vpc.subnet_cidrs //output from module that creates the VPC
  fgt_extra_config  = data.template_file.fgt_extra_config.rendered //Added config to publish new VIP at public interface to student server

  config_spoke = true
  spoke        = local.spoke
  hubs         = local.hubs

  vpc-spoke_cidr = [module.student_vpc.subnet_cidrs["bastion"]]
}
# Create data template extra-config fgt (Create new VIP to lab server and policies)
data "template_file" "fgt_extra_config" {
  template = file("./templates/fgt_extra-config.tpl")
  vars = {
    external_ip   = cidrhost(module.student_vpc.subnet_cidrs["public"], 10)  //Default IP assigned in create Fortigate module in public subnet
    mapped_ip     = cidrhost(module.student_vpc.subnet_cidrs["bastion"], 10) //IP assigned to server in bastion subnet
    external_port = "80"
    mapped_port   = "80"
    public_port   = "port1"
    private_port  = "port2"
    suffix        = "80"
  }
}
# Call FGT instance module with necessary variables to deploy
module "student_fgt" {
  source = "./modules/fgt"

  tags          = local.tags
  region        = local.region
  instance_type = local.fgt_instance_type
  keypair       = aws_key_pair.keypair.key_name

  license_type = local.license_type
  fgt_build    = local.fgt_build
  fgt_config   = module.student_fgt_config.fgt_config

  subnet_ids   = module.student_vpc.subnet_ids //output from module that creates the VPC
  subnet_cidrs = module.student_vpc.subnet_cidrs
  sg_ids       = module.student_vpc.sg_ids
  rt_ids       = module.student_vpc.rt_ids
}