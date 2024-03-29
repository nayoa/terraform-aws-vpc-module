######
# VPC
######
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "evesleep"

    workspaces {
      name = "dev"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "example_aws_networking" {
  source                       = "git::ssh://git@gitlab.com/evesleep/infrastructure/terraform-modules/vpc.git?ref=0.9.7"
  name                         = "example_aws_networking"
  vpc_cidr                     = "10.0.0.0/16"
  public_subnets               = ["10.0.101.0/24", "10.0.102.0/24"]
  private_subnets              = ["10.0.1.0/24", "10.0.2.0/24"]
  create_database_subnet_group = true
  azs                          = ["eu-west-1a", "eu-west-1b"]
  enable_public_nat_gateway    = true
  enable_private_nat_gateway   = true
  key_pair_name                = "test"



  tags = {
    Application = "Dev Networking"
    CreatedBy   = "Terraform"
    Environment = "Dev"
  }
}
