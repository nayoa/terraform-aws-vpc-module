locals {
  nat_gateway_count = "${var.single_private_nat_gateway ? 1 : (var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length)}"
  environment       = lookup("${var.tags}", "Environment")
  max_subnet_length = max(length(var.private_subnets))
}
