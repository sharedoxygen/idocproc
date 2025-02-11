provider "aws" {
  region = var.aws_region
}

# Main VPC Configuration
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  
  name = "idocproc-vpc"
  cidr = "10.0.0.0/16"
  
  azs              = ["us-west-2a", "us-west-2b"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]
  database_subnets = ["10.0.201.0/24", "10.0.202.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  create_database_subnet_group = true
}

# Security Group Configuration
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"
  
  name        = "idocproc-sg"
  description = "Security group for iDocProc services"
  vpc_id      = module.vpc.vpc_id
  
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# RDS Database Configuration
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.1.0"
  
  identifier = "idocproc-db"
  
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  
  db_name  = "idocproc"
  username = "admin"
  password = var.db_password
  port     = 5432
  
  vpc_security_group_ids = [module.security_group.security_group_id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
}

# ECS Cluster Configuration
module "idocproc_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "4.1.0"
  
  cluster_name = "idocproc-cluster"
  
  cluster_configuration = {
    execute_command_configuration = {
      logging = "DEFAULT"
    }
  }
  
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
        base   = 1
      }
    }
  }
}

# Output Definitions
output "security_group_id" {
  value = module.security_group.security_group_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

terraform {
  backend "local" {
    path = "../../build_logs/terraform.tfstate"  # Keeps state within project
  }
} 