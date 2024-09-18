resource "aws_imagebuilder_image_pipeline" "this" {
  name                             = local.name
  description                      = "EC2 Image Builder pipeline for ${local.name}"
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.this.arn
  image_recipe_arn                 = aws_imagebuilder_image_recipe.this.arn

  tags = { Name = local.name }
}

resource "aws_imagebuilder_image_recipe" "this" {
  name         = local.name
  description  = "EC2 Image Builder recipe for ${local.name}"
  parent_image = "arn:aws:imagebuilder:${local.region}:aws:image/amazon-linux-2023-arm64/x.x.x"
  version      = "1.0.0"

  component {
    component_arn = "arn:aws:imagebuilder:${local.region}:aws:component/amazon-cloudwatch-agent-linux/1.0.1/1"
  }

  tags = { Name = local.name }
}

resource "aws_imagebuilder_infrastructure_configuration" "this" {
  name                          = local.name
  description                   = "Infrastructure configuration for ${local.name}"
  instance_profile_name         = aws_iam_instance_profile.imagebuilder.name
  instance_types                = ["t4g.micro"]
  terminate_instance_on_failure = true

  tags = { Name = local.name }
}

resource "aws_iam_role" "imagebuilder" {
  name               = "${local.name}-imagebuilder"
  description        = "IAM role for ${local.name} EC2 Image Builder"
  assume_role_policy = data.aws_iam_policy_document.imagebuilder_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder",
  ]

  tags = { Name = "${local.name}-imagebuilder" }
}

data "aws_iam_policy_document" "imagebuilder_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_instance_profile" "imagebuilder" {
  name = "${local.name}-imagebuilder"
  role = aws_iam_role.imagebuilder.name

  tags = { Name = "${local.name}-imagebuilder" }
}
