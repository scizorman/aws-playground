resource "aws_ecr_repository" "user_api" {
  name                 = "user-api"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecs_task_definition" "user_api" {
  family                   = "user-api"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "user-api"
      image = "217082601537.dkr.ecr.ap-northeast-1.amazonaws.com/user-api"
      portMappings = [
        {
          containerPort = 50051
          protocol      = "tcp"
        }
      ]
    }
  ])
}
