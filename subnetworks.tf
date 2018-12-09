#resource "google_compute_subnetwork" "subnet1" {
#  ip_cidr_range = "10.0.1.0/24"
#  name = "subnet1"
#  network = "${google_compute_network.tftg_network.self_link}"
#  region = "us-west1"
#}

resource "aws_subnet" "subnet1" {
  cidr_block        = "${cidrsubnet(aws_vpc.tfta-environment.cidr_block, 1, 1)}"
  vpc_id            = "${aws_vpc.tfta-environment.id}"
  availability_zone = "${var.aws_zone}"
}

#resource "aws_subnet" "subnet2" {
#  cidr_block        = "${cidrsubnet(aws_vpc.tfta-environment.cidr_block, 2, 2)}"
#  vpc_id            = "${aws_vpc.tfta-environment.id}"
#  availability_zone = "us-west-2b"
#}

resource "aws_security_group" "subnetsecurity" {
  vpc_id = "${aws_vpc.tfta-environment.id}"
  name   = "Private subnet SG"

  ingress {
    cidr_blocks = [
      "${aws_vpc.tfta-environment.cidr_block}",
    ]

    from_port = "${var.service_port}"
    to_port   = "${var.service_port}"
    protocol  = "tcp"
  }
}
