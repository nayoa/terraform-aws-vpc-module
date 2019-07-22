output "vpc_id" {
  value = module.example_aws_networking.vpc_id
}

output "vpc_arn" {
  value = module.example_aws_networking.vpc_arn
}

output "internet_gateway_id" {
  value = module.example_aws_networking.internet_gateway_id
}

output "public_subnet_id" {
  value = module.example_aws_networking.public_subnet_id
}

output "private_subnet_id" {
  value = module.example_aws_networking.private_subnet_id
}

output "nat_gateway_id" {
  value = module.example_aws_networking.nat_gateway_id
}

output "eip_public_ip" {
  value = module.example_aws_networking.eip_public_ip
}

output "elasticache_subnet_group" {
  value = module.example_aws_networking.elastiacache_subnet_group
}

output "database_subnet_group" {
  value = module.example_aws_networking.database_subnet_group
}

