module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "my-api"
  description   = "API Gateway with SQS integration"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_methods = ["POST", "OPTIONS"]
    allow_origins = ["*"]
  }

  integrations = {
    "POST /send-message" = {
      integration_type = "AWS_PROXY"
      connection_type  = "INTERNET"
      integration_uri  = module.lambda.lambda_function_arn
    }
  }

  stages = {
    dev = {
      auto_deploy = true
    }
  }
}

