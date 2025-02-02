variable "region" {
  description = "AWS regio"
  type = string
}

variable "mongo_public_key" {
    type = string
}
variable "mongo_private_key" {
    type = string
}

variable "lambda_role_name" {
  description = "SQS Lambda IAM Role name"
  type = string
}

variable "cluster_name" {
  description = "Mongo DB cluster name"
  type = string
}

variable "org_id" {
  description = "MongoDB Atlas Organization ID"
  type        = string
}

variable "project_name" {
  description = "MongoDB Atlas project name"
  type        = string
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database user password"
  type        = string
}

variable "database_name" {
  description = "Database name for user permissions"
  type        = string
}
