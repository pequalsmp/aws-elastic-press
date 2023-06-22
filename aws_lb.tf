resource "aws_lb" "alb1" {
  name               = "alb1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.vpc.default_security_group_id]
  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]

  enable_deletion_protection = false
}

resource "aws_alb_target_group" "apache" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.apache.arn
  }
}

resource "aws_alb_listener_rule" "forward" {
  listener_arn = aws_alb_listener.front_end.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.apache.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
