resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]
}

data "aws_iam_policy_document" "github_plan_assume_role" {
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
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${local.github_repository_subject}:pull_request",
        "repo:${local.github_repository_subject}:ref:refs/heads/main"
      ]
    }
  }
}

resource "aws_iam_role" "github_terraform_plan" {
  name               = "${local.project_name}-github-terraform-plan"
  assume_role_policy = data.aws_iam_policy_document.github_plan_assume_role.json
}
