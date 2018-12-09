variable "aws_vpc_name" {
  type        = "string"
  description = "The AWS VPC name"
}

variable aws_cidr {
  default     = "10.0.0.0/27"
  type        = "string"
  description = "IP CIDR range for AWS VPC"
}

variable "aws_region" {
  type = "string"
}

variable "aws_zone" {
  type = "string"
}

variable "aws_server_size" {
  type        = "string"
  description = "AWS instance sizing for the server"
}

variable "service_port" {
  type        = "string"
  description = "Web Server default port"
}

// Output variables

output "aws_cider_subnet1" {
  value = "${aws_subnet.subnet1.cidr_block}"
}

output "aws_instance_id" {
  value = "${aws_instance.webserver.id}"
}

output "aws_private_ip" {
  value = "${aws_instance.webserver.private_ip}"
}

output "aws_private_dns" {
  value = "${aws_instance.webserver.private_dns}"
}
