data "aws_caller_identity" "ecr_push" {}

data "aws_partition" "ecr_push" {}

data "aws_iam_policy_document" "github_ecr_push_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_ecr_push" {
  name               = "${local.project_name}-github-ecr-push"
  assume_role_policy = data.aws_iam_policy_document.github_ecr_push_assume_role.json
}

data "aws_iam_policy_document" "github_ecr_push" {
  statement {
    sid       = "GetAuthorizationToken"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    sid = "PushVaultwardenImage"

    actions = [
      "ecr:DescribeImages",
      "ecr:BatchCheckLayerAvailability",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]

    resources = [
      "arn:${data.aws_partition.ecr_push.partition}:ecr:${var.aws_region}:${data.aws_caller_identity.ecr_push.account_id}:repository/${local.project_name}-prod"
    ]
  }
}

resource "aws_iam_policy" "github_ecr_push" {
  name   = "${local.project_name}-github-ecr-push"
  policy = data.aws_iam_policy_document.github_ecr_push.json
}

resource "aws_iam_role_policy_attachment" "github_ecr_push" {
  role       = aws_iam_role.github_ecr_push.name
  policy_arn = aws_iam_policy.github_ecr_push.arn
}