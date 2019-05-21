terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "eve"
  }
}

locals {
  max_subnet_length = "${max(length(var.private_subnets), length(var.database_subnets))}"
  nat_gateway_count = "${var.single_private_nat_gateway ? 1 : (var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length)}"
}
