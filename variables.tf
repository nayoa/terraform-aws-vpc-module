variable "name" {
  type        = string
  default     = ""
  description = "Name to be used on all the resources as identifier"
}

variable "tags" {
  type        = map
  default     = {}
  description = "A mapping of tags to assign to the networking resources"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "vpc_enable_dns_support" {
  type        = bool
  default     = true
  description = "A boolean flag to enable/disable DNS support in the VPC"
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  default     = false
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
}

variable "vpc_assign_generated_ipv6_cidr_block" {
  type        = bool
  default     = true
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block"
}

variable "vpc_secondary_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
}

variable "public_subnets" {
  type        = list(string)
  default     = []
  description = "A list of public subnets inside the VPC"
}

variable "private_subnets" {
  type        = list(string)
  default     = []
  description = "A list of private subnets inside the VPC"
}

variable "one_nat_gateway_per_az" {
  type        = bool
  default     = false
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
}

variable "create_database_subnet_group" {
  type        = bool
  default     = true
  description = "Controls if database subnet group should be created"
}

variable "create_elasticache_subnet_group" {
  type        = bool
  default     = true
  description = "Controls if elasticache subnet group should be created"
}

variable "azs" {
  type        = list(string)
  default     = []
  description = "A list of availability zones in the region"
}

variable "enable_public_nat_gateway" {
  type        = bool
  default     = false
  description = "Should be true if you want to provision NAT Gateways for each of your public networks"
}

variable "enable_private_nat_gateway" {
  type        = bool
  default     = false
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
}

variable "single_private_nat_gateway" {
  type        = bool
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = false
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = false
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address"
}

variable "bastion_instance_type" {
  default     = "t2.micro"
  description = "The type of the instance"
}

variable "autoscaling_min_size" {
  type        = number
  default     = 1
  description = "The minimum size of the auto scale group"
}

variable "autoscaling_max_size" {
  type        = number
  default     = 1
  description = "The maximum size of the auto scale group"
}

variable "key_pair_name" {
  description = "The name of the key pair to attach to instances"
}

variable "autoscaling_desired_capacity" {
  type        = number
  default     = 1
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "account_id" {
  type        = string
  default     = "651854267583"
  description = "AWS Account ID to grab Hardened AMI from"
}
