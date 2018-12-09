variable "aws_vpc_name" {
  default     = "tft_vpc"
  type        = "string"
  description = "The AWS VPC name"
}

variable aws_ip_cidr_range {
  default     = "10.0.0.0/27"
  type        = "string"
  description = "IP CIDR range for AWS VPC"
}

variable "aws_regions" {
  type = "map"

  default = {
    or = "us-west-2"
    ca = "us-west-1"
    va = "us-east-1"
    br = "sa-east-1"
    ir = "eu-west-1"
    uk = "eu-west-2"
    fr = "eu-west-3"
  }
}

variable "aws_zones" {
  type = "map"

  default = {
    zone1 = "a"
    zone2 = "b"
  }
}

variable "service_port" {
  type        = "string"
  default     = "80"
  description = "Web Server default port"
}
