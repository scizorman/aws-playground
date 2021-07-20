resource "aws_ecr_repository" "aws_playground_api" {
  name                 = "aws-playground/api"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecs_task_definition" "aws_playground_api" {
  family             = "aws-playground-api"
  cpu                = "256"
  memory             = "512"
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode(
    [
      {
        name  = "nginx"
        image = "nginx:1.21.1"
        portMappings = [
          {
            containerPort = 80
            hostPort      = 80
          }
        ]
      }
    ]
  )
}

resource "aws_security_group" "aws_playground_api" {
  name        = "aws-playground-api"
  description = "The security group for aws-playground API."
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "aws-playground-api"
  }
}

resource "aws_security_group_rule" "aws_playground_api" {
  security_group_id = aws_security_group.aws_playground_api.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]
}

resource "aws_ecs_service" "aws_playground_api" {
  name            = "aws-playground-api"
  depends_on      = [aws_lb_listener_rule.aws_playground]
  cluster         = aws_ecs_cluster.aws_playground.name
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.aws_playground_api.arn

  network_configuration {
    subnets = [
      data.terraform_remote_state.network.outputs.subnet_id.private_1a,
      data.terraform_remote_state.network.outputs.subnet_id.private_1c,
      data.terraform_remote_state.network.outputs.subnet_id.private_1d,
    ]
    security_groups = [aws_security_group.aws_playground_api.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.aws_playground.arn
    container_name   = "nginx"
    container_port   = 80
  }
}
