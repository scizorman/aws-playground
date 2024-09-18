resource "aws_iam_role" "app" {
  name               = "${local.name}-app"
  description        = "IAM role for the ${local.name} EC2 instances"
  assume_role_policy = data.aws_iam_policy_document.app_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  ]
}

data "aws_iam_policy_document" "app_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "ssm.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "app" {
  role   = aws_iam_role.app.name
  policy = data.aws_iam_policy_document.app.json
}

data "aws_iam_policy_document" "app" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions",
    ]
    resources = [aws_s3_bucket.artifact.arn]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]
    resources = ["${aws_s3_bucket.artifact.arn}/*"]
  }
}

resource "aws_iam_instance_profile" "this" {
  name = local.name
  role = aws_iam_role.app.name
}

resource "aws_launch_template" "this" {
  name                                 = local.name
  description                          = "Launch template for the ${local.name} EC2 instances"
  image_id                             = "ami-0aea344faf91f8adf"
  instance_type                        = "c7g.medium"
  instance_initiated_shutdown_behavior = "terminate"
  ebs_optimized                        = true

  credit_specification {
    cpu_credits = "standard"
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [aws_security_group.app.id]
  }

  placement {
    tenancy = "default"
  }

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = local.name }
  }

  tag_specifications {
    resource_type = "volume"
    tags          = { Name = local.name }
  }

  tags = { Name = local.name }

  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = local.name
  max_size                  = 3
  min_size                  = 0
  desired_capacity          = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier       = module.vpc.private_subnets

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 1
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this.id
        version            = "$Latest"
      }
    }
  }
}

# resource "aws_autoscaling_attachment" "this" {
#   autoscaling_group_name = aws_autoscaling_group.this.name
#   lb_target_group_arn    = aws_lb_target_group.this.arn
# }

resource "aws_security_group" "app" {
  name   = "${local.name}-app"
  vpc_id = module.vpc.vpc_id

  tags = { Name = "${local.name}-app" }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow inbound trrafic from the ALB"
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

resource "aws_vpc_security_group_egress_rule" "app_to_all_ipv4" {
  security_group_id = aws_security_group.app.id
  description       = "Allow all outbound trrafic to IPv4 addresses"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "app_to_all_ipv6" {
  security_group_id = aws_security_group.app.id
  description       = "Allow all outbound trrafic to IPv6 addresses"
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}
