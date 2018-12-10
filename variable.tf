variable "aws_vpc_name" {
  type        = "string"
  description = "The AWS VPC name"
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

variable "docker_image" {
  type        = "string"
  description = "Docker image to instanciate the service"
}

variable "service_port" {
  type        = "string"
  description = "Web Server default port"
}

variable "healthcheck_path" {
  type        = "string"
  description = "Path to health check"
}

// Output variables

output "Server-DNS" {
  value = "${module.computing.server-dns}"
}

output "VPC-id" {
  value = "${module.networking.vpc_id}"
}

output "Healthcheck" {
  value = "${module.computing.lb_helathcheck}"
}
