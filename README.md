# lambda_iac
Create Lambda function with Terrafrom

## Purpose
Devops Excercise:
  Use terrafrom to create the following infrastructure elements
- Create VPC with 3 public subnets and 3 private subnets across multiple availability zones.
  - VPC should include Internet Gateway, Route tables and NAT Gateway to Enable connectivity.
- Lambda function packaged as a Docker container deployed in the private subnets.
- Lambda function should be integrated with:
  - API Gateway (as a public REST endpoint).
  - An SQS queue for message processing.
- A MongoDB Atlas cluster (free tier or sandbox).
- A CloudFront distribution to serve static assets from an S3 bucket.
- A Cognito user pool with one test user.
