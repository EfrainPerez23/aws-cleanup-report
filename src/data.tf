data "aws_caller_identity" "current_identity" {}

data "aws_iam_policy_document" "report_cleanup_bucket_policy_document" {
  version = local.aws_policy_version
  statement {
    sid    = "DenyUnencryptedTraffic"
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "*"
    }

    actions = [
      "s3:*"
    ]

    resources = [
      aws_s3_bucket.report_cleanup_bucket.arn,
      "${aws_s3_bucket.report_cleanup_bucket.arn}/*",
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

  }

}

data "aws_iam_policy_document" "lambda_trust_policy" {
  version = local.aws_policy_version
  statement {

    sid    = "AllowLambdaToAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "scheduler_trust_policy" {
  version = "2012-10-17"
  statement {

    sid    = "AllowSchedulerToAssumeRole"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current_identity.account_id]
    }
  }
}

data "aws_iam_policy_document" "scheduler_execution_permissions" {
  version = local.aws_policy_version
  statement {
    sid    = "AllowSchedulerToInvokeLambda"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "${aws_lambda_function.aws_cleanup_report_lambda.arn}:*",
      aws_lambda_function.aws_cleanup_report_lambda.arn
    ]
  }
}




data "aws_iam_policy_document" "lambda_execution_permissions" {
  version = local.aws_policy_version
  statement {
    sid    = "AllowS3Access"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudWatchLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.lambda_aws_cleanup_report_log_group.arn}:*"
    ]
  }
}

data "archive_file" "lambda_function_zip" {
  type        = "zip"
  source_dir  = "lambda/"
  output_path = "function.zip"
}
