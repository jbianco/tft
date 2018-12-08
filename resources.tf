resource "google_compute_network" "tftg_network" {
  name = "devnetwork"
  auto_create_subnetworks = true
}

resource "aws_vpc" "tfta-environment" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "tfta-aws-vpc"
  }
}