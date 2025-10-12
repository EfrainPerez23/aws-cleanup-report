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
