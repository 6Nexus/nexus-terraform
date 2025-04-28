terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-east-1"
}

module "network" {
  source       = "./modules/network"
  vpc_cidr     = "10.0.0.0/24"
  public_cidr  = "10.0.0.0/25"
  private_cidr = "10.0.0.128/25"
}

module "ec2" {
  source       = "./modules/ec2"
  ami_id       = "ami-0f9de6e2d2f067fca"
  instance_type = "t2.small"
  vpc_id       = module.network.vpc_id
  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
  key_name     = "id_rsa"
}