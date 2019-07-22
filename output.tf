output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_arn" {
  value = aws_vpc.main.arn
}

output "internet_gateway_id" {
  value = aws_internet_gateway.gw.id
}

output "public_subnet_id" {
  value = aws_subnet.public[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.gw[*].id
}

output "eip_public_ip" {
  value = aws_eip.nat[*].public_ip
}

output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

output "elasticache_subnet_group" {
  value = aws_elasticache_subnet_group.elasticache[*].name
}

output "database_subnet_group" {
  value = aws_db_subnet_group.database[*].id
}