# AWS Multi-Environment Infrastructure — Terraform IaC Platform

A modular, production-grade Terraform project that provisions and manages AWS infrastructure across **DEV**, **STAGING**, and **PROD** environments. Built to mirror enterprise financial services infrastructure patterns with proper network segmentation, IAM least-privilege design, remote state management, and drift detection.

## Architecture Overview

```
aws-terraform-infra/
├── modules/
│   ├── vpc/          # VPC, subnets, NAT gateway, route tables
│   ├── ec2/          # EC2 instances, security groups, key pairs
│   ├── rds/          # RDS instances, subnet groups, parameter groups
│   ├── s3/           # S3 buckets, versioning, lifecycle policies
│   └── iam/          # IAM roles, policies, instance profiles
├── envs/
│   ├── dev/          # DEV environment root module
│   ├── staging/      # STAGING environment root module
│   └── prod/         # PROD environment root module
└── scripts/          # Helper scripts for plan/apply/destroy
```

## Tech Stack

| Tool | Version | Purpose |
|---|---|---|
| Terraform | >= 1.5 | Infrastructure as Code |
| AWS Provider | >= 5.0 | AWS resource management |
| AWS S3 | — | Remote state backend |
| AWS DynamoDB | — | State locking |

## Features

- **Modular design** — reusable modules per AWS service, called from each environment
- **Remote state** — S3 backend with DynamoDB locking per environment
- **Least-privilege IAM** — separate roles per service with scoped policies
- **Drift detection** — scheduled `terraform plan` via CI/CD pipeline
- **Environment parity** — same modules across DEV/STAGING/PROD with different var files
- **CloudFormation parity check** — parallel CF stack validates IaC consistency

## Prerequisites

```bash
terraform >= 1.5.0
aws-cli >= 2.0
aws credentials configured (~/.aws/credentials or environment variables)
```

## Usage

```bash
# Initialize a specific environment
cd envs/dev
terraform init

# Plan changes
terraform plan -var-file="dev.tfvars"

# Apply changes
terraform apply -var-file="dev.tfvars"

# Destroy (use with caution)
terraform destroy -var-file="dev.tfvars"
```

## Remote State Setup

Before first use, bootstrap the S3 backend and DynamoDB table:

```bash
cd scripts
chmod +x bootstrap-state.sh
./bootstrap-state.sh dev
```

## Environment Variables

| Variable | Description | Example |
|---|---|---|
| `aws_region` | AWS deployment region | `us-east-1` |
| `environment` | Environment name | `dev` / `staging` / `prod` |
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `instance_type` | EC2 instance type | `t3.micro` |
| `db_instance_class` | RDS instance class | `db.t3.micro` |

## Security Notes

- No hardcoded credentials anywhere in this repo
- All secrets managed via AWS Secrets Manager or environment variables
- S3 buckets have versioning and encryption enabled by default
- All resources tagged with environment, owner, and project labels

## Author

**Djamal Tighilt Ferhat** — DevOps & Cloud Engineer
[github.com/dtighiltferhat](https://github.com/dtighiltferhat) · [linkedin.com/in/djamal-tighilt-ferhat-983343110](https://linkedin.com/in/djamal-tighilt-ferhat-983343110)
