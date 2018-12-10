resource "aws_alb" "server_lb" {
  name            = "clock-service"
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
