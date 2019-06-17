# AWS Virtual Private Cloud (VPC) Terraform Module

Terraform module that creates VPC resources in AWS

These types of resources are supported:

* [AWS VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)
* [AWS VPC - IPV4 CIDR Block Association](https://www.terraform.io/docs/providers/aws/r/vpc_ipv4_cidr_block_association.html)
* [AWS Internet Gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)
* [AWS Route Table](https://www.terraform.io/docs/providers/aws/r/route_table.html)
* [AWS Route](https://www.terraform.io/docs/providers/aws/r/route.html)
* [AWS Route Table Association](https://www.terraform.io/docs/providers/aws/r/route_table_association.html)
* [AWS Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
* [AWS EIP](https://www.terraform.io/docs/providers/aws/r/eip.html)
* [AWS NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html)
* [AWS DB Subnet Group](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html)
* [AWS Lauch Configuration](https://www.terraform.io/docs/providers/aws/r/launch_configuration.html)
* [AWS Autoscaling Group](https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html)
* [AWS Security Group](https://www.terraform.io/docs/providers/aws/r/security_group.html)

## Dependencies

<details>
  <summary>
   What to install to use the module locally
  </summary>

* [Terraform >= v0.12](https://learn.hashicorp.com/terraform/getting-started/install.html)
```bash
$ brew install terraform
```
* [AWS CLI >= v1.16.130](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
```bash
$ brew install awscli
```

Have programmatic access to Eve's AWS account (currently Production)

Export your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` of the AWS account you want to upload the CSV reports to.

**OR**

Ensure your credentials are in your `~/.aws/credentials` file.

If they're not, you can add them by doing:

```shell
$ aws configure
AWS Access Key ID []: <enter-aws-access-key>
AWS Secret Access Key []: <enter-aws-secret-key>
Default region name []: <enter-region-id> # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions
Default output format []: <leave-blank>
```

You can then check your CLI is using the correct credentials by doing:

```shell
$ aws sts get-caller-identity
```

</details>

## Usage

```hcl
provider "aws" {
  region = "eu-west-1"
}

module "example_aws_networking" {
  source                       = "git::ssh://git@gitlab.com/evesleep/infrastructure/terraform-modules/vpc.git"
  name                         = "example_aws_networking"
  vpc_cidr                     = "10.0.0.0/16"
  public_subnets               = ["10.0.128.0/20", "10.0.144.0/20"]
  private_subnets              = ["10.0.0.0/19", "10.0.32.0/19"]
  one_nat_gateway_per_az       = true
  create_database_subnet_group = false
  azs                          = ["eu-west-1a", "eu-west-1b"]
  enable_public_nat_gateway    = true
  enable_private_nat_gateway   = true
  key_pair_name                = "test"

  resource_tags {
    Name          = "dev_networking"
    CreatedBy    = "Joe Bloggs"
    Environment   = "dev"
    ManagementBy = "Product Team"
  }
}

```

## Examples

* [VPC example](examples/main.tf)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | Name to be used on all the resources as identifier | string | - | no |
| resource_tags | A mapping of tags to assign to the networking resources | map | {} | no |
| vpc_cidr | The CIDR block for the VPC | string | -| yes |
| vpc_enable_dns_support | A boolean flag to enable/disable DNS support in the VPC | string | true | no |
| vpc_enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC | string | false | no |
| vpc_assign_generated_ipv6_cidr_block | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block | string | false | no |
| vpc_secondary_cidr_blocks | List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool | - | [] | no |
| public_subnets | A list of public subnets inside the VPC | - | [] | no |
| private_subnets | A list of private subnets inside the VPC | - | [] | no |
| one_nat_gateway_per_az | Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs` | string | false | no |
| create_database_subnet_group | Controls if database subnet group should be created | string | true | no |
| database_subnets | A list of database subnets | - | [] | no |
| create_database_nat_gateway_route | Controls if a nat gateway route should be created to give internet access to the database subnets | string | false | no |
| azs | A list of availability zones in the region | - | [] | false |
| create_database_internet_gateway_route | Controls if an internet gateway route for public database access should be created | string | false | no |
| enable_public_nat_gateway | Should be true if you want to provision NAT Gateways for each of your public networks | string | false | no |
| enable_private_nat_gateway | Should be true if you want to provision NAT Gateways for each of your private networks | string | false | no |
| single_private_nat_gateway | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | string | false | no |
| map_public_ip_on_launch | Specify true to indicate that instances launched into the subnet should be assigned a public IP address | string | false | no |
| bastion_instance_type | The size of instance to launch | string | t2.micro | no |
| autoscaling_min_size | The minimum size of the auto scale group | string | 1 | no |
| autoscaling_max_size | The maximum size of the auto scale group | string | 2 | no |
| key_pair_name | The name of the key pair to attach to instances | string | - | yes |
| autoscaling_desired_size | The number of Amazon EC2 instances that should be running in the group | string | 1 | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_arn | Amazon Resource Name (ARN) of VPC |
| internet_gateway_id | The ID of the Internet Gateway |
| public_subnet_id | The ID(s) of the public subnet(s) |
| private_subnet_id | The ID(s) of the private subnet(s) |
| nat_gateway_gateway_id | The ID(s) of the NAT Gateway(s) |
| eip_public_ip | Contains the public IP address |

## Run Tests

When a commit is made to the repo - the [Gitlab pipeline](.gitlab-ci.yml) is triggered and does a terraform validate and format on the Hashicorp Configuration Language (HCL).

## Improvements

* Replace [user_data](templates/user_data.sh) script with an Ansible playbook
