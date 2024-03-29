### AMI

data "aws_ami" "hardened_ami" {
  most_recent = true
  owners      = [var.account_id]

  filter {
    name   = "name"
    values = ["hardened-ami-*"]
  }
}

### Get IAM Managed policy for SSM

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = data.aws_iam_policy.ssm.arn
}

### Launch configuration

resource "aws_launch_configuration" "bastion" {
  iam_instance_profile        = aws_iam_instance_profile.bastion.name
  name_prefix                 = "bastion-${var.name}-"
  key_name                    = var.key_pair_name
  image_id                    = data.aws_ami.hardened_ami.id
  instance_type               = var.bastion_instance_type
  security_groups             = [aws_security_group.bastion.id]
  user_data                   = templatefile("${path.module}/templates/user_data.tmpl", { environment = local.environment, ansible_bucket = var.ansible_s3_bucket, private_key = var.base64_webmaster_private_key, ansible_prefix = local.ansible_prefix, bastion_ip = aws_eip.bastion.public_ip })
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

### Autoscaling group

resource "aws_autoscaling_group" "bastion" {
  name_prefix          = "bastion-${var.name}-"
  launch_configuration = aws_launch_configuration.bastion.name
  min_size             = var.autoscaling_min_size
  max_size             = var.autoscaling_max_size
  desired_capacity     = var.autoscaling_desired_capacity
  termination_policies = ["OldestInstance"]
  health_check_type    = "EC2"
  vpc_zone_identifier  = aws_subnet.public[*].id

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "bastion-${local.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Application"
    value               = lookup(var.tags, "Application")
    propagate_at_launch = true
  }

  tag {
    key                 = "CreatedBy"
    value               = lookup(var.tags, "CreatedBy")
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = lookup(var.tags, "Environment")
    propagate_at_launch = true
  }
}

### Security Group

resource "aws_security_group" "bastion" {
  name_prefix = "bastion-${var.name}-"
  vpc_id      = aws_vpc.main.id
  description = "Security Group for Bastion ${local.environment}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["217.138.170.18/32"]
    description = "Office IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, map("Name", "bastion-${local.environment}"))
}

### Bastion Elastic IP

resource "aws_eip" "bastion" {
  vpc = true

  tags = var.tags
}

### Bastion IAM Role

data "aws_iam_policy_document" "bastion_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "bastion" {
  name               = "bastion-${local.environment}"
  assume_role_policy = data.aws_iam_policy_document.bastion_assume.json
}

data "aws_iam_policy_document" "bastion" {
  statement {
    actions = [
      "ec2:AssociateAddress",
      "ec2:DescribeAddresses",
      "ec2:AllocateAddress",
      "ec2:DescribeInstances",
      "s3:*"

    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "bastion" {
  name   = "associate-eip-${local.environment}"
  role   = aws_iam_role.bastion.id
  policy = data.aws_iam_policy_document.bastion.json
}

resource "aws_iam_instance_profile" "bastion" {
  name = "associate-eip-${local.environment}"
  role = aws_iam_role.bastion.name
}
