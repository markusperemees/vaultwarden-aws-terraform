data "aws_caller_identity" "github_apply" {}

data "aws_partition" "github_apply" {}

data "aws_iam_policy_document" "github_apply_assume_role" {
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
        "repo:${var.github_owner}@${var.github_owner_id}/${var.github_repository}@${var.github_repository_id}:environment:prod"
      ]
    }
  }
}

resource "aws_iam_role" "github_terraform_apply" {
  name                 = "${local.project_name}-github-terraform-apply"
  assume_role_policy   = data.aws_iam_policy_document.github_apply_assume_role.json
  max_session_duration = 3600
}

resource "aws_iam_role_policy_attachment" "github_apply_power_user" {
  role       = aws_iam_role.github_terraform_apply.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

data "aws_iam_policy_document" "github_apply_iam" {
  statement {
    sid = "ManageVaultwardenRoles"

    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:ListRoleTags",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:PutRolePolicy",
      "iam:GetRolePolicy",
      "iam:DeleteRolePolicy"
    ]

    resources = [
      "arn:${data.aws_partition.github_apply.partition}:iam::${data.aws_caller_identity.github_apply.account_id}:role/${local.project_name}-prod-*"
    ]
  }

  statement {
    sid = "AttachEcsExecutionPolicy"

    actions = [
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy"
    ]

    resources = [
      "arn:${data.aws_partition.github_apply.partition}:iam::${data.aws_caller_identity.github_apply.account_id}:role/${local.project_name}-prod-*"
    ]

    condition {
      test     = "ArnEquals"
      variable = "iam:PolicyARN"
      values = [
        "arn:${data.aws_partition.github_apply.partition}:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
      ]
    }
  }

  statement {
    sid     = "PassVaultwardenRoles"
    actions = ["iam:PassRole"]

    resources = [
      "arn:${data.aws_partition.github_apply.partition}:iam::${data.aws_caller_identity.github_apply.account_id}:role/${local.project_name}-prod-*"
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "github_apply_iam" {
  name   = "${local.project_name}-github-terraform-apply-iam"
  role   = aws_iam_role.github_terraform_apply.id
  policy = data.aws_iam_policy_document.github_apply_iam.json
}