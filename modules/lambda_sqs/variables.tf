variable function_name {
  type = string
}

variable role_arn {
  description = "Lambda function IAM Role arn"
  type = string
}

variable event_source_arn {
  description = "SQS queue arn"
  type = string
}

variable event_source_url {
  description = "SQS queue url"
  type = string
}

variable mongo_secret_arn {
  description = "Mongo DB Secet - connection strings"
  type = string
}

variable aws_ecr_repository {
  description = "AWS ECR repository URL"
  type = string
}

variable image_tag {
  description = "Docker image version tag"
  type = string
}
