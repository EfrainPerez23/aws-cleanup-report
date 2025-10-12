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