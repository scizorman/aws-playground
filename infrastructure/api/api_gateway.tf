resource "aws_ecr_repository" "api_gateway" {
  name                 = "api-gateway"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecs_task_definition" "api_gateway" {
  family                   = "api-gateway"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "api-gateway"
      image = "217082601537.dkr.ecr.ap-northeast-1.amazonaws.com/api-gateway"
      portMappings = [
        {
          containerPort = 1323
          protocol      = "tcp"
        }
      ]
    }
  ])
}
