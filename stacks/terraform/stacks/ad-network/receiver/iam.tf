data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    principals {
      type        = "Federated"
      identifiers = [local.github_actions_oidc_provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:scizorman/aws-playground:*"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]
  }
}

resource "aws_iam_role" "github_actions_artifact_uploader" {
  name               = local.github_actions_artifact_uploader_role_name
  description        = "IAM role for uploading ${local.name} artifacts built on GitHub Actions to S3 bucket"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json

  tags = { Name = local.github_actions_artifact_uploader_role_name }
}

resource "aws_iam_role_policy" "github_actions_artifact_uploader" {
  name   = local.github_actions_artifact_uploader_role_name
  role   = aws_iam_role.github_actions_artifact_uploader.name
  policy = data.aws_iam_policy_document.githubactions_artifact_uploader.json
}

data "aws_iam_policy_document" "githubactions_artifact_uploader" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.artifact.arn]
  }

  statement {
    actions   = ["s3:*Object"]
    resources = ["${aws_s3_bucket.artifact.arn}/*"]
  }
}
