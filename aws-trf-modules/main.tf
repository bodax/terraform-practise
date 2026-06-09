provider "aws" {
  region = var.region
}

module "network" {
  source = "./modules/network"

  vpc_name         = "cmtr-031bfa7b-vpc"
  vpc_cidr         = "10.10.0.0/16"
  igw_name         = "cmtr-031bfa7b-igw"
  route_table_name = "cmtr-031bfa7b-rt"

  subnets = [
    {
      name = "cmtr-031bfa7b-subnet-public-a"
      cidr = "10.10.1.0/24"
      az   = "eu-west-1a"
    },
    {
      name = "cmtr-031bfa7b-subnet-public-b"
      cidr = "10.10.3.0/24"
      az   = "eu-west-1b"
    },
    {
      name = "cmtr-031bfa7b-subnet-public-c"
      cidr = "10.10.5.0/24"
      az   = "eu-west-1c"
    },
  ]
}

module "network_security" {
  source = "./modules/network_security"

  vpc_id               = module.network.vpc_id
  allowed_ip_range     = var.allowed_ip_range
  ssh_sg_name          = "cmtr-031bfa7b-ssh-sg"
  public_http_sg_name  = "cmtr-031bfa7b-public-http-sg"
  private_http_sg_name = "cmtr-031bfa7b-private-http-sg"
}

module "application" {
  source = "./modules/application"

  vpc_id               = module.network.vpc_id
  subnet_ids           = module.network.subnet_ids
  ssh_sg_id            = module.network_security.ssh_sg_id
  public_http_sg_id    = module.network_security.public_http_sg_id
  private_http_sg_id   = module.network_security.private_http_sg_id
  launch_template_name = "cmtr-031bfa7b-template"
  asg_name             = "cmtr-031bfa7b-asg"
  lb_name              = "cmtr-031bfa7b-lb"
  instance_type        = "t3.micro"
}
