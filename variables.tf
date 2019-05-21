variable "name" {
  type        = "string"
  default     = ""
  description = "Name to be used on all the resources as identifier"
}

variable "resource_tags" {
  type        = "map"
  default     = {}
  description = "A mapping of tags to assign to the networking resources"
}

variable "vpc_cidr" {
  type        = "string"
  description = "The CIDR block for the VPC"
}

variable "vpc_enable_dns_support" {
  type        = "string"
  default     = "true"
  description = "A boolean flag to enable/disable DNS support in the VPC"
}

variable "vpc_enable_dns_hostnames" {
  type        = "string"
  default     = "false"
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
}

variable "vpc_assign_generated_ipv6_cidr_block" {
  type        = "string"
  default     = "false"
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block"
}

variable "vpc_secondary_cidr_blocks" {
  default     = []
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
}

variable "public_subnets" {
  default     = []
  description = "A list of public subnets inside the VPC"
}

variable "private_subnets" {
  default     = []
  description = "A list of private subnets inside the VPC"
}

variable "one_nat_gateway_per_az" {
  type        = "string"
  default     = false
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
}

variable "create_database_subnet_group" {
  type        = "string"
  default     = true
  description = "Controls if database subnet group should be created"
}

variable "database_subnets" {
  default     = []
  description = "A list of database subnets"
}

variable "create_database_subnet_route_table" {
  default     = false
  description = "Controls if separate route table for database should be created"
}

variable "create_database_nat_gateway_route" {
  default     = false
  description = "Controls if a nat gateway route should be created to give internet access to the database subnets"
}

variable "azs" {
  default     = []
  description = "A list of availability zones in the region"
}

variable "create_database_internet_gateway_route" {
  default     = false
  description = "Controls if an internet gateway route for public database access should be created"
}

variable "enable_public_nat_gateway" {
  default     = false
  description = "Should be true if you want to provision NAT Gateways for each of your public networks"
}

variable "enable_private_nat_gateway" {
  default     = false
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
}

variable "single_private_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = false
}

variable "map_public_ip_on_launch" {
  default     = false
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
}
