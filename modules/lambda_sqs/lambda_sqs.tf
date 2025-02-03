module "lambda_container-image" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.20.1"

  function_name  = var.function_name
  description    = "Lambda function from ECR docker image"
  package_type   = "Image"
  create_package = false
  image_uri      = "${var.aws_ecr_repository}:${var.image_tag}"

  create_role = false  # Prevents module from creating a new IAM role
  lambda_role = var.role_arn
  handler = "package.lambda_handler"
  
  environment_variables = {
    SQS_QUEUE_URL     = var.event_source_url
    MONGO_SECRET_ARN  = var.mongo_secret_arn
  }

  event_source_mapping = [{
    event_source_arn = var.event_source_arn
    batch_size       = 5
    }] 
}
