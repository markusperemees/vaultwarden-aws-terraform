data "aws_iam_policy_document" "github_plan_state" {
  statement {
    sid     = "ListStateBucket"
    actions = ["s3:ListBucket"]

    resources = [
      aws_s3_bucket.terraform_state.arn
    ]
  }

  statement {
    sid = "ReadState"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.terraform_state.arn}/vaultwarden/*/terraform.tfstate"
    ]
  }

  statement {
    sid = "ManageStateLock"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.terraform_state.arn}/vaultwarden/*/terraform.tfstate.tflock"
    ]
  }
}

resource "aws_iam_policy" "github_plan_state" {
  name   = "${local.project_name}-github-terraform-plan-state"
  policy = data.aws_iam_policy_document.github_plan_state.json
}

resource "aws_iam_role_policy_attachment" "github_plan_state" {
  role       = aws_iam_role.github_terraform_plan.name
  policy_arn = aws_iam_policy.github_plan_state.arn
}