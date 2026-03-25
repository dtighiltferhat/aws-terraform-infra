# envs/prod/prod.tfvars

aws_region  = "us-east-1"
environment = "prod"

vpc_cidr             = "10.2.0.0/16"
public_subnet_cidrs  = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
private_subnet_cidrs = ["10.2.10.0/24", "10.2.11.0/24", "10.2.12.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]

instance_type     = "t3.medium"
db_instance_class = "db.t3.small"
