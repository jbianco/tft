#resource "google_compute_network" "tftg_network" {
#  name                    = "devnetwork"
#  auto_create_subnetworks = false
#}

resource "aws_vpc" "tfta-environment" {
  cidr_block           = "${var.aws_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "${var.aws_vpc_name}"
  }
}
