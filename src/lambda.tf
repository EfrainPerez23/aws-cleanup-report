resource "aws_cloudwatch_log_group" "lambda_aws_cleanup_report_log_group" {
  name              = var.lambda_log_group_name
  retention_in_days = var.retention_logs_days

  tags = {
    porpose = local.porpose
  }

}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = var.lambda_policy_name
  description = "Permissions for Lambda to access S3 and CloudWatch Logs"
  policy      = data.aws_iam_policy_document.lambda_execution_permissions.json
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = var.lambda_role_name
  description        = "Role for Lambda to access S3 and CloudWatch Logs"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
  tags = {
    porpose = local.porpose
  }
}

resource "aws_iam_role_policy_attachment" "lambda_custom_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}

resource "aws_lambda_function" "aws_cleanup_report_lambda" {
  filename         = data.archive_file.lambda_function_zip.output_path
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_function_zip.output_base64sha256
  runtime          = "python3.13"
  architectures    = ["arm64"]

  logging_config {
    log_group  = aws_cloudwatch_log_group.lambda_aws_cleanup_report_log_group.name
    log_format = "Text"
  }

  environment {
    variables = {
      REPORT_BUCKET_NAME = var.aws_s3_bucket_name
    }
  }

  tags = {
    porpose = local.porpose
  }
}