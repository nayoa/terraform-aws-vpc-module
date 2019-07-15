### VPC

resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = var.vpc_enable_dns_hostnames
  enable_dns_support               = var.vpc_enable_dns_support
  assign_generated_ipv6_cidr_block = var.vpc_assign_generated_ipv6_cidr_block

  tags = var.tags
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  count = length(var.vpc_secondary_cidr_blocks) > 0 ? length(var.vpc_secondary_cidr_blocks) : 0

  vpc_id = aws_vpc.main.id

  cidr_block = element(var.vpc_secondary_cidr_blocks, count.index)
}

### Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

### Public Routing

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, map("Name", "Public Subnet (${local.environment})"))
}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets)

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

### Private Routing

resource "aws_route_table" "private" {
  count  = local.max_subnet_length > 0 ? local.nat_gateway_count : 0
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, map("Name", "Private (${local.environment})"))
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, var.single_private_nat_gateway ? 0 : count.index)
}

### Database Routes

resource "aws_route_table" "database" {
  count = var.create_database_subnet_route_table && length(var.database_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, map("Name", "Database (${local.environment})"))
}

resource "aws_route" "database_internet_gateway" {
  count = var.create_database_subnet_route_table && length(var.database_subnets) > 0 && var.create_database_internet_gateway_route && ! var.create_database_nat_gateway_route ? 1 : 0

  route_table_id         = aws_route_table.database[count.index]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "database_nat_gateway" {
  count = var.create_database_subnet_route_table && length(var.database_subnets) > 0 && ! var.create_database_internet_gateway_route && var.create_database_nat_gateway_route && var.enable_private_nat_gateway ? local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.gw[*].id, count.index)
}

### Public Subnet

resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 && (! var.one_nat_gateway_per_az || length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(concat(var.public_subnets, list("")), count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.tags, map("Name", "Public Subnet (${local.environment})"))
}

### Private Subnet

resource "aws_subnet" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = element(var.azs, count.index)

  tags = merge(var.tags, map("Name", "Private Subnet (${local.environment})"))
}

### Database Subnet

resource "aws_subnet" "database" {
  count = length(var.database_subnets) > 0 ? length(var.database_subnets) : 0

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = element(var.azs, count.index)

  tags = merge(var.tags, map("Name", "Database Subnet (${local.environment})"))
}

resource "aws_db_subnet_group" "database" {
  count = length(var.database_subnets) > 0 && var.create_database_subnet_group ? 1 : 0

  name        = lower(var.name)
  description = "Database subnet group for ${var.name}"
  subnet_ids  = [aws_subnet.database[*].id]

  tags = merge(var.tags, map("Name", "Database Subnet Group (${local.environment})"))
}

### Nat Gateway

resource "aws_eip" "nat" {
  count = var.enable_public_nat_gateway ? local.nat_gateway_count : 0
  vpc   = true

  tags = var.tags
}

resource "aws_nat_gateway" "gw" {
  count         = var.enable_public_nat_gateway ? local.nat_gateway_count : 0
  allocation_id = element(aws_eip.nat[*].id, count.index)
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  tags = var.tags

  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route" "private_nat_gateway" {
  count = var.enable_private_nat_gateway ? local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.gw.*.id, count.index)

  timeouts {
    create = "5m"
  }
}
