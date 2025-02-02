module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  single_nat_gateway = true
  enable_nat_gateway = true

  public_subnet_tags = {
    "vpc_name" = var.vpc_name
    "subnet_type" = "Public"  
  }
  
  private_subnet_tags = {
    "vpc_name" = var.vpc_name
    "subnet_type" = "Private"  
  }
}
