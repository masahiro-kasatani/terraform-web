
###########################################################################
# ALB
###########################################################################
resource "aws_lb" "main" {
  name                       = "${var.name_prefix}-${var.env}"
  load_balancer_type         = "application"
  subnets                    = var.subnet_ids
  security_groups            = [aws_security_group.alb.id]
  # tfsec:ignore:aws-elb-alb-not-public
  internal                   = false # ignored
  enable_deletion_protection = false
}

resource "aws_lb_listener" "http_blue" {
  count = var.create_blue == true ? 1 : 0

  protocol = "HTTP"
  port     = var.listener_blue.http_port
  default_action {
    type = "redirect"
    redirect {
      port        = var.listener_blue.https_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  load_balancer_arn = aws_lb.main.arn
  tags = {
    Name = "${var.name_prefix}-${var.listener_blue.name}-${var.env}"
  }
}

resource "aws_lb_listener" "https_blue" {
  count = var.create_blue == true ? 1 : 0

  protocol   = "HTTPS"
  port       = var.listener_blue.https_port
  ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue[0].arn
  }
  load_balancer_arn = aws_lb.main.arn
  certificate_arn   = var.listener_blue.certificate_arn
  lifecycle {
    ignore_changes = [default_action]
  }
  tags = {
    Name = "${var.name_prefix}-${var.listener_blue.name}-${var.env}"
  }
}

resource "aws_lb_target_group" "blue" {
  count = var.create_blue == true ? 1 : 0

  name                 = "${var.name_prefix}-${var.target_group_blue.name}-${var.env}"
  protocol             = "HTTP"
  target_type          = var.target_group_blue.target_type
  vpc_id               = var.vpc_id
  port                 = var.target_group_blue.port
  deregistration_delay = var.target_group_blue.deregistration_delay
  health_check {
    port                = var.container_port
    matcher             = var.target_group_blue.health_check.matcher
    healthy_threshold   = var.target_group_blue.health_check.healthy_threshold
    unhealthy_threshold = var.target_group_blue.health_check.unhealthy_threshold
    interval            = var.target_group_blue.health_check.interval
    timeout             = var.target_group_blue.health_check.timeout
    path                = var.target_group_blue.health_check.path
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http_green" {
  count = var.create_green == true ? 1 : 0

  protocol = "HTTP"
  port     = var.listener_green.http_port
  default_action {
    type = "redirect"
    redirect {
      port        = var.listener_green.https_port
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  load_balancer_arn = aws_lb.main.arn
  tags = {
    Name = "${var.name_prefix}-${var.listener_green.name}-${var.env}"
  }
}

resource "aws_lb_listener" "https_green" {
  count = var.create_green == true ? 1 : 0

  protocol   = "HTTPS"
  port       = var.listener_green.https_port
  ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green[0].arn
  }
  load_balancer_arn = aws_lb.main.arn
  certificate_arn   = var.listener_green.certificate_arn
  lifecycle {
    ignore_changes = [default_action]
  }
  tags = {
    Name = "${var.name_prefix}-${var.listener_green.name}-${var.env}"
  }
}

resource "aws_lb_target_group" "green" {
  count = var.create_green == true ? 1 : 0

  name                 = "${var.name_prefix}-${var.target_group_green.name}-${var.env}"
  protocol             = "HTTP"
  target_type          = var.target_group_blue.target_type
  vpc_id               = var.vpc_id
  port                 = var.target_group_green.port
  deregistration_delay = var.target_group_green.deregistration_delay
  health_check {
    port                = var.container_port
    matcher             = var.target_group_green.health_check.matcher
    healthy_threshold   = var.target_group_green.health_check.healthy_threshold
    unhealthy_threshold = var.target_group_green.health_check.unhealthy_threshold
    interval            = var.target_group_green.health_check.interval
    timeout             = var.target_group_green.health_check.timeout
    path                = var.target_group_green.health_check.path
  }
  lifecycle {
    create_before_destroy = true
  }
}

###########################################################################
# Security Group
###########################################################################
resource "aws_security_group" "alb" {
  name   = "${var.name_prefix}-alb-${var.env}"
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    # tfsec:ignore:aws-vpc-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"] # ignored
  }
}
