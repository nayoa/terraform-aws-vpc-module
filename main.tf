locals {
  max_subnet_length = "${max(length(var.private_subnets), length(var.database_subnets))}"
  nat_gateway_count = "${var.single_private_nat_gateway ? 1 : (var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length)}"
}

resource "random_string" "launch_configuration" {
  length = 5
}

resource "random_string" "autoscaling_group" {
  length = 5
}
