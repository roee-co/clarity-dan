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
