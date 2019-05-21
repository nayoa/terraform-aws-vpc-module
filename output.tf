output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "vpc_arn" {
  value = "${aws_vpc.main.arn}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.gw.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public.*.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private.*.id}"
}

output "nat_gateway_id" {
  value = "${aws_nat_gateway.gw.*.id}"
}

output "eip_public_ip" {
  value = "${aws_eip.nat.*.public_ip}"
}
