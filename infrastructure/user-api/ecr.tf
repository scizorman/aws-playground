resource "aws_ecr_repository" "user-api" {
  name                 = "user-api"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}
