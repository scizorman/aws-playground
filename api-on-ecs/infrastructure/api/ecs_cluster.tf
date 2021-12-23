resource "aws_ecs_cluster" "aws_playground" {
  name = "aws-playground"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
