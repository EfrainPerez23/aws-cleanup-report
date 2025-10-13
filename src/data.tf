data "aws_iam_policy_document" "report_cleanup_bucket_policy_document" {
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


data "aws_iam_policy_document" "lambda_execution_permissions" {
  statement {
    sid    = "AllowS3Access"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.report_cleanup_bucket.arn,
      "${aws_s3_bucket.report_cleanup_bucket.arn}/*"
    ]
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
  source_file = "lambda/lambda_function.py"
  output_path = "lambda/function.zip"
}
