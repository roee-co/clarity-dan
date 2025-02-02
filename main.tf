# ─────────────────────────────────────────────────────────────
# Providers Configuration
# ─────────────────────────────────────────────────────────────
provider "aws" {
  region = "eu-central-1"
}

provider "mongodbatlas" {
  public_key  = var.mongo_public_key
  private_key = var.mongo_private_key
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.7.0"
    }
  }

  backend "s3" {
    bucket  = "danb-kops-state"
    key     = "lambda/state/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

# ─────────────────────────────────────────────────────────────
# VPC Module
# ─────────────────────────────────────────────────────────────
module "vpc_iac" {
  source              = "./modules/vpc"
  vpc_name           = "lambda_vpc"
  vpc_cidr           = "10.130.0.0/16"
  availability_zones = ["eu-central-1a", "eu-central-1b"]
  private_subnets    = ["10.130.1.0/24", "10.130.2.0/24"]
  public_subnets     = ["10.130.3.0/24", "10.130.4.0/24"]

  tags = {
    Name        = "lambda_vpc"
    Environment = "dev"
    CreatedBy   = "Dan Bar-Or"
    Date        = "01-Feb-2025"
  }
}

# ─────────────────────────────────────────────────────────────
# AWS ECR Repository for Lambda
# ─────────────────────────────────────────────────────────────
resource "aws_ecr_repository" "lambda_ecr" {
  name                 = "sqs-processor"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# ─────────────────────────────────────────────────────────────
# AWS SQS Queue
# ─────────────────────────────────────────────────────────────
resource "aws_sqs_queue" "api_queue" {
  name                      = "api-message-queue"
  visibility_timeout_seconds = 30
  message_retention_seconds  = 86400  # 1 day
}

# ─────────────────────────────────────────────────────────────
# IAM Role for Lambda
# ─────────────────────────────────────────────────────────────
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# IAM Policy for Lambda (Allow Access to SQS)
resource "aws_iam_policy" "lambda_sqs_policy" {
  name        = "${var.lambda_role_name}-policy"
  description = "Allows Lambda to read from SQS and write to DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["sqs:CreateQueue", "sqs:ReceiveMessage", "sqs:SendMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
      Effect   = "Allow"
      Resource = aws_sqs_queue.api_queue.arn
    }]
  })
}

# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}

# ─────────────────────────────────────────────────────────────
# Lambda Function with SQS Event Source
# ─────────────────────────────────────────────────────────────
module "sqs_processor_lambda" {
  source             = "./modules/lambda_sqs"
  function_name      = "sqs-message-processor"
  role_arn           = aws_iam_role.lambda_role.arn
  event_source_arn   = aws_sqs_queue.api_queue.arn
}
