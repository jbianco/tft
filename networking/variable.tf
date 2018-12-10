variable "aws_vpc_name" {}
variable "aws_region" {}
variable "aws_zone" {}
variable "service_port" {}

variable aws_cidr {
  default     = "10.0.0.0/26"
  type        = "string"
  description = "IP CIDR range for AWS VPC"
}

// Output variables

output "aws_cider_subnet1" {
  value = "${aws_subnet.subnet1.cidr_block}"
}
