resource "aws_s3_bucket" "report_cleanup_bucket" {
  bucket = var.aws_s3_bucket_name
  tags_all = {
    porpose = "report_cleanup_bucket"
  }

  object_lock_enabled = var.object_lock_enabled

  lifecycle {
    ignore_changes = [tags_all, tags]
  }
}

resource "aws_s3_bucket_versioning" "report_cleanup_bucket_versioning" {
  bucket = aws_s3_bucket.report_cleanup_bucket.id
  versioning_configuration {
    status = var.bucket_versioning_enabled ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_policy" "report_cleanup_bucket_policy" {
  bucket = aws_s3_bucket.report_cleanup_bucket.id
  policy = data.aws_iam_policy_document.report_cleanup_bucket_policy_document.json
}
