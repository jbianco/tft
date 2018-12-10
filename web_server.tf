provider "aws" {
  region = "${var.aws_region}"
}

module "networking" {
  source       = "./networking"
  aws_region   = "${var.aws_region}"
  aws_vpc_name = "${var.aws_vpc_name}"
  aws_zone     = "${var.aws_zone}"
  service_port = "${var.service_port}"
}

module "computing" {
  source           = "./computing"
  aws_server_size  = "${var.aws_server_size}"
  docker_image     = "${var.docker_image}"
  server_sg_id     = "${module.networking.server_sg_id}"
  service_port     = "${var.service_port}"
  subnet1_id       = "${module.networking.subnet1_id}"
  subnet2_id       = "${module.networking.subnet2_id}"
  healthcheck_path = "${var.healthcheck_path}"
  vpc_id           = "${module.networking.vpc_id}"
}
