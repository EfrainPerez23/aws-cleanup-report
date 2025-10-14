resource "aws_iam_policy" "lambda_execution_scheduler_policy" {
  name        = var.scheduler_name
  description = "Permissions for scheduler to invoke Lambda"
  policy      = data.aws_iam_policy_document.scheduler_execution_permissions.json
}

resource "aws_iam_role" "scheduler_execution_scheduler_role" {
  name               = var.scheduler_role_name
  description        = "Role for scheduler to invoke Lambda"
  assume_role_policy = data.aws_iam_policy_document.scheduler_trust_policy.json

  tags = {
    porpose = local.porpose
  }
}

resource "aws_iam_role_policy_attachment" "scheduler_custom_policy_attachment" {
  role       = aws_iam_role.scheduler_execution_scheduler_role.name
  policy_arn = aws_iam_policy.lambda_execution_scheduler_policy.arn
}

resource "aws_scheduler_schedule" "aws_clenaup_report_scheduler" {
  name                = "aws-clenaup-report-scheduler"
  description         = "Schedule for AWS Cleanup Report"
  schedule_expression = var.schedule_expression


  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = aws_lambda_function.aws_cleanup_report_lambda.arn
    role_arn = aws_iam_role.scheduler_execution_scheduler_role.arn
  }

}
