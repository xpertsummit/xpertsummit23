# AWS resourcers prefix description
variable "prefix" {
  type    = string
  default = "xs23"
}

variable "tags" {
  description = "Attribute for tag Enviroment"
  type        = map(any)
  default = {
    Owner   = "student-0"
    Project = "xs23"
  }
}

variable "admin_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "admin_port" {
  type    = string
  default = "8443"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/24"
}

variable "region" {
  type = map(any)
  default = {
    id  = "eu-west-1"
    az1 = "eu-west-1a"
    az2 = "eu-west-1c"
  }
}

variable "region_az" {
  type    = string
  default = "az1"
}

variable "subnet_names" {
  type    = list(string)
  default = ["public", "private", "mgmt", "bastion"]
}