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

variable "org_id" {
  description = "MongoDB Atlas Organization ID"
  type        = string
}

variable "project_name" {
  description = "MongoDB Atlas project name"
  type        = string
}

variable "project_id" {
  description = "MongoDB Atlas project ID"
  type        = string
}

variable "ip_address" {
  description = "IP Address of the NAT Gateway"
  type        = string
}
