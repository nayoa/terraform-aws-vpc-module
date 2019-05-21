######
# VPC
######

module "example_aws_networking" {
  source                       = ".."
  name                         = "example_aws_networking"
  region                       = "eu-west-1"
  vpc_cidr                     = "10.0.0.0/16"
  public_subnets               = ["10.0.128.0/20", "10.0.144.0/20"]
  private_subnets              = ["10.0.0.0/19", "10.0.32.0/19"]
  one_nat_gateway_per_az       = true
  create_database_subnet_group = false
  azs                          = ["eu-west-1a", "eu-west-1b"]
  enable_public_nat_gateway    = true

  resource_tags {
    name          = "dev_networking"
    created_by    = "Nayo Akinyele"
    environment   = "dev"
    management_by = "Product Team"
  }
}
