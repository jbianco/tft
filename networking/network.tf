resource "aws_vpc" "server-environment" {
  cidr_block           = "${var.aws_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "${var.aws_vpc_name}"
  }
}

resource "aws_internet_gateway" "server-gateway" {
  vpc_id = "${aws_vpc.server-environment.id}"

  tags {
    Name = "vpc-gateway"
  }
}

// Network output values passed to main

output "vpc_id" {
  value = "${aws_vpc.server-environment.id}"
}
