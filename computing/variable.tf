variable "aws_server_size" {}
variable "docker_image" {}
variable "server_sg_id" {}
variable "service_port" {}
variable "subnet1_id" {}
variable "subnet2_id" {}
variable "healthcheck_path" {}
variable "vpc_id" {}

// Output variables
//output "aws_instance_id" {
//  value = "${aws_instance.webserver.id}"
//}
//
//output "aws_private_ip" {
//  value = "${aws_instance.webserver.private_ip}"
//}
//
//output "aws_private_dns" {
//  value = "${aws_instance.webserver.private_dns}"
//}

output "server-dns" {
  value = "${aws_alb.server_lb.dns_name}"
}

output "lb_helathcheck" {
  value = "${aws_alb_target_group.lb_targets.health_check}"
}
