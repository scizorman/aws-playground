resource "aws_security_group" "alb" {
  name        = "aws-playground-alb"
  description = "The security group for aws-playground ALB."
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-playground-alb"
  }
}

resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb" "aws_playground" {
  load_balancer_type = "application"
  name               = "aws-playground"
  security_groups    = [aws_security_group.alb.id]
  subnets = [
    data.terraform_remote_state.network.outputs.subnet_id.public_1a,
    data.terraform_remote_state.network.outputs.subnet_id.public_1c,
    data.terraform_remote_state.network.outputs.subnet_id.public_1d,
  ]
}

resource "aws_lb_listener" "aws_playground" {
  port              = "80"
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.aws_playground.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK!"
    }
  }
}

resource "aws_lb_target_group" "aws_playground" {
  name        = "aws-playground"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
  port        = 1323
  protocol    = "HTTP"
  target_type = "ip"

  health_check {
    port = 1323
    path = "/"
  }
}

resource "aws_lb_listener_rule" "aws_playground" {
  listener_arn = aws_lb_listener.aws_playground.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_playground.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
