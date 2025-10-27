variable "aws_s3_bucket_name" {
  type    = string
  default = "report-cleaner-bucket"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "object_lock_enabled" {
  type    = bool
  default = false
}

variable "bucket_versioning_enabled" {
  type    = bool
  default = false
}

variable "retention_logs_days" {
  type    = number
  default = 3
}

variable "lambda_function_name" {
  type    = string
  default = "aws-report-lambda-cleanup-role"
}

variable "lambda_policy_name" {
  type    = string
  default = "aws-report-lambda-cleanup-policy"
}

variable "scheduler_name" {
  type    = string
  default = "aws-report-scheduler-cleanup"
}

variable "lambda_role_name" {
  type    = string
  default = "aws-report-lambda-cleanup-role"
}

variable "scheduler_role_name" {
  type    = string
  default = "aws-report-scheduler-cleanup-role"
}

variable "lambda_log_group_name" {
  type    = string
  default = "/custom/lambda/aws-report-cleanup"

}

variable "schedule_expression" {
  type    = string
  default = "rate(30 days)"
}