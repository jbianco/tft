resource "aws_launch_configuration" "server_launch" {
  name            = "server-launch-configuration"
  image_id        = "ami-0c24d5499b254c53e"
  instance_type   = "${var.aws_server_size}"
  security_groups = ["${var.server_sg_id}"]
  user_data       = "${data.template_file.server_lc_user-data.rendered}"
  key_name        = "dev"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "server_asg" {
  name                 = "server_asg"
  max_size             = 2
  min_size             = 1
  desired_capacity     = 2
  vpc_zone_identifier  = ["${var.subnet1_id}", "${var.subnet2_id}"]
  launch_configuration = "${aws_launch_configuration.server_launch.name}"
  health_check_type    = "ELB"
}

resource "aws_alb" "server_lb" {
  name            = "server-load-balancer"
  security_groups = ["${var.server_sg_id}"]
  subnets         = ["${var.subnet1_id}", "${var.subnet2_id}"]

  tags {
    Name = "Server_load_balancer"
  }
}

resource "aws_alb_listener" "lb_listener" {
  load_balancer_arn = "${aws_alb.server_lb.arn}"
  port              = "${var.service_port}"
  protocol          = "HTTP"

  "default_action" {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.lb_targets.arn}"
  }
}

resource "aws_alb_target_group" "lb_targets" {
  name     = "lg-targer"
  port     = "${var.service_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  tags {
    name = "load_balancer_targets"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "${var.healthcheck_path}"
    port                = "${var.service_port}"
  }
}

resource "aws_autoscaling_attachment" "asg_attacher" {
  autoscaling_group_name = "${aws_autoscaling_group.server_asg.id}"
  alb_target_group_arn   = "${aws_alb_target_group.lb_targets.arn}"
}

data "template_file" "server_lc_user-data" {
  template = "${file("${path.module}/server_bootstrap.tpl")}"

  vars {
    image = "${var.docker_image}"
  }
}
