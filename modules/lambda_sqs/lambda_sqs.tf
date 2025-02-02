module "sqs_processor_lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = var.function_name

  create_role = false  # Prevents module from creating a new IAM role
  lambda_role = var.role_arn

  package_type  = "Zip"
  # modify later for Docker
  # package_type = "Image"
  # image_uri     = "${aws_ecr_repository.lambda_ecr.repository_url}:latest"

  source_path   = "./modules/lambda_sqs/lambda_src"
  handler       = "index.handler"
  runtime       = "python3.9"

  event_source_mapping = [{
    event_source_arn = var.event_source_arn
    batch_size       = 5
  }]
  
  # modify later for Docker
  
  # image_uri     = "${aws_ecr_repository.lambda_ecr.repository_url}:latest"

}
