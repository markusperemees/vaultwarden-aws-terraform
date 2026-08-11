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

data "aws_iam_policy_document" "github_plan_read" {
  statement {
    sid = "ReadStateBucketConfiguration"
    actions = [
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketLocation",
      "s3:GetBucketLogging",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketOwnershipControls",
      "s3:GetBucketPolicy",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetBucketVersioning",
      "s3:GetBucketWebsite",
      "s3:GetEncryptionConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetReplicationConfiguration"
    ]
    resources = [aws_s3_bucket.terraform_state.arn]
  }

  statement {
    sid = "ReadIamConfiguration"
    actions = [
      "iam:GetOpenIDConnectProvider",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListOpenIDConnectProviderTags",
      "iam:ListPolicyTags",
      "iam:ListPolicyVersions",
      "iam:ListRolePolicies",
      "iam:ListRoleTags"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "ReadNetwork"
    actions   = ["ec2:Describe*"]
    resources = ["*"]
  }

  statement {
    sid = "ReadEcrRepository"
    actions = [
      "ecr:DescribeRepositories",
      "ecr:GetLifecyclePolicy",
      "ecr:GetRepositoryPolicy",
      "ecr:ListTagsForResource"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadDatabase"
    actions = [
      "rds:Describe*",
      "rds:ListTagsForResource"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadSecrets"
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:ListSecrets",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadFileSystem"
    actions = [
      "elasticfilesystem:Describe*",
      "elasticfilesystem:ListTagsForResource"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadEcs"
    actions = [
      "ecs:Describe*",
      "ecs:List*"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "ReadLoadBalancer"
    actions   = ["elasticloadbalancing:Describe*"]
    resources = ["*"]
  }

  statement {
    sid = "ReadCertificate"
    actions = [
      "acm:DescribeCertificate",
      "acm:GetCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadDns"
    actions = [
      "route53:Get*",
      "route53:List*"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadMonitoring"
    actions = [
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListTagsForResource",
      "logs:DescribeLogGroups",
      "logs:ListTagsForResource"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ReadEncryptionMetadata"
    actions = [
      "kms:DescribeKey",
      "kms:ListAliases"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_plan_read" {
  name   = "${local.project_name}-github-terraform-plan-read"
  policy = data.aws_iam_policy_document.github_plan_read.json
}

resource "aws_iam_role_policy_attachment" "github_plan_read" {
  role       = aws_iam_role.github_terraform_plan.name
  policy_arn = aws_iam_policy.github_plan_read.arn
}
