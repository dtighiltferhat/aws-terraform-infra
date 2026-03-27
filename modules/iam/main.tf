# modules/iam/main.tf
# IAM roles, policies, and instance profiles

# ── EC2 Instance Role ─────────────────────────────────────────────────────────
resource "aws_iam_role" "ec2_role" {
  name = "${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = var.common_tags
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ── S3 Read Policy (scoped to project buckets only) ───────────────────────────
resource "aws_iam_policy" "s3_read" {
  name        = "${var.environment}-s3-read-policy"
  description = "Least-privilege S3 read access for EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject", "s3:ListBucket"]
      Resource = [
        "arn:aws:s3:::${var.environment}-app-bucket",
        "arn:aws:s3:::${var.environment}-app-bucket/*"
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read.arn
}

# ── CloudWatch Logs Policy ────────────────────────────────────────────────────
resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "${var.environment}-cloudwatch-logs-policy"
  description = "Allow EC2 instances to push logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ]
      Resource = "arn:aws:logs:*:*:*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}
