#------------------------------------------------------------------------------
# Deploy student FGT (NOT UPDATE)
#------------------------------------------------------------------------------
# Call ftg_config module with necessary variables to generate FGT config
module "student_fgt_config" {
  source = "./modules/fgt_config"

  api_key          = local.externalid_token                       //API key will be the external token provided in the lab
  subnet_cidrs     = module.student_vpc.subnet_cidrs              //output from module that creates the VPC

  config_spoke = true
  spoke        = local.spoke
  hubs         = local.hubs

  vpc-spoke_cidr = [module.student_vpc.subnet_cidrs["bastion"]]
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