# AWS Cleanup Report Module

This Terraform module automates the process of generating cleanup reports for AWS resources.  
It helps you identify unused or underutilized resources and store the report in an S3 bucket.  

## Features

- Creates an **S3 bucket** for storing CSV cleanup reports.
- Configures a **bucket policy** to enforce HTTPS-only access.
- Enables **versioning** for the S3 bucket (optional).
- Deploys a **Lambda function** that generates the report.
- Schedules the Lambda using **EventBridge** (CloudWatch Events) with a configurable cron expression.

## Usage

```hcl
module "aws_cleanup_report" {
  source = "git::https://github.com/EfrainPerez23/aws-cleanup-report.git"

  bucket_name              = "report-cleaner-bucket"
  lambda_schedule          = "rate(1 day)"
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