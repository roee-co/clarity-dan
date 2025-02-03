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
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket  = "danb-kops-state"
    key     = "prerun/state/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

# ─────────────────────────────────────────────────────────────
# Add github runner extranl IP to Atlas allowd IP addresses
# ─────────────────────────────────────────────────────────────
resource "mongodbatlas_project_ip_access_list" "ip_list" {
  project_id = var.project_id
  ip_address = var.ip_address
}
