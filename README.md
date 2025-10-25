# AWS Cleanup Report Module

This Terraform module automates the detection and reporting of insecure or unused S3 buckets.  
It generates a **CSV report** listing **S3 buckets that are empty** and **do not have an HTTPS-only (deny HTTP) policy enforced**.

## Features

- Creates an **S3 bucket** to store the generated cleanup CSV reports.
- Deploys a **Lambda function** that:
  - Scans all existing S3 buckets in the account.
  - Identifies buckets **without an HTTPS deny policy**.
  - Detects buckets that are **empty (no objects stored)**.
  - Generates a **CSV report** summarizing those buckets.
  - Uploads the report automatically to the configured S3 bucket.
- Uses **EventBridge (CloudWatch Events)** to schedule the Lambda on a defined interval (e.g., daily).

## Usage

```hcl
module "aws_cleanup_report" {
  source = "git::https://github.com/EfrainPerez23/aws-cleanup-report.git"

  bucket_name               = "report-cleaner-bucket"
  lambda_schedule           = "rate(1 day)"
  bucket_versioning_enabled = true
}
```

## Running with Nix Flake

This repository provides a Nix Flake with Terraform v1.13.3 preinstalled, so you can run Terraform without worrying about your local environment.

1. Clone the repository
```bash
    git clone https://github.com/EfrainPerez23/aws-cleanup-report.git
    cd aws-cleanup-report
```

2. Enter the development shell with Terraform:
```bash
    nix develop
```

3. Once inside the shell, you can run Terraform commands as usual:
```bash
    terraform init
    terraform plan
    terraform apply
```