resource "aws_subnet" "subnet1" {
  cidr_block        = "${cidrsubnet(aws_vpc.server-environment.cidr_block, 1, 1)}"
  vpc_id            = "${aws_vpc.server-environment.id}"
  availability_zone = "${var.aws_zone}"
}

resource "aws_subnet" "subnet2" {
  cidr_block        = "${cidrsubnet(aws_vpc.server-environment.cidr_block, 2, 1)}"
  vpc_id            = "${aws_vpc.server-environment.id}"
  availability_zone = "us-west-2b"
}

resource "aws_security_group" "server_security_group" {
  name        = "Server SG"
  description = "Server VPC security group"
  vpc_id      = "${aws_vpc.server-environment.id}"

  // HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Subnet output values passed to main

output "server_sg_id" {
  value = "${aws_security_group.server_security_group.id}"
}

output "private_cidr" {
  value = "${aws_subnet.subnet1.cidr_block}"
}

output "subnet1_id" {
  value = "${aws_subnet.subnet1.id}"
}

output "subnet2_id" {
  value = "${aws_subnet.subnet2.id}"
}
