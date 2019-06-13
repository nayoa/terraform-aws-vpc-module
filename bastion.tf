### AMI

data "aws_ami" "hardened_ami" {
  most_recent = true
  owners      = ["${local.ami_owner}"]

  filter {
    name   = "name"
    values = ["hardened-ami-*"]
  }
}

### Launch configuration

resource "aws_launch_configuration" "bastion" {
  name_prefix                 = "bastion-${var.name}-"
  key_name                    = "${var.key_pair_name}"
  image_id                    = "${data.aws_ami.hardened_ami.id}"
  instance_type               = "${var.bastion_instance_type}"
  security_groups             = [aws_security_group.bastion.id]
  user_data                   = file("${path.module}/templates/user_data.sh")
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

### Autoscaling group

resource "aws_autoscaling_group" "bastion" {
  name_prefix          = "bastion-${var.name}-"
  launch_configuration = "${aws_launch_configuration.bastion.name}"
  min_size             = "${var.autoscaling_min_size}"
  max_size             = "${var.autoscaling_max_size}"
  termination_policies = ["OldestInstance"]
  health_check_type    = "EC2"
  vpc_zone_identifier  = aws_subnet.public[*].id

  lifecycle {
    create_before_destroy = true
  }

}

### Security Group

resource "aws_security_group" "bastion" {
  name        = "bastion-${var.name}"
  vpc_id      = "${aws_vpc.main.id}"
  description = "${var.name} - Bastion Security Group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["79.173.165.219/32"]
    description = "Office IP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${var.resource_tags}"
}