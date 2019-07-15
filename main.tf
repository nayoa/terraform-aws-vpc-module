locals {
  nat_gateway_count = "${var.single_private_nat_gateway ? 1 : (var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length)}"
  environment       = lookup("${var.resource_tags}", "Environment")
  ami_owner         = "${local.environment == "production" ? local.prod_account_id : local.dev_account_id}"
  dev_account_id    = "651854267583"
  prod_account_id   = "586848946515"
  public_tag        = "Public ${local.environment}"
  private_tag       = "Private ${local.environment}"
  database_tag      = "Database ${local.environment}"
  max_subnet_length = max(
    length(var.private_subnets),
    length(var.database_subnets),
  )
}
