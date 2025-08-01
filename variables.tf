# AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Environment
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

# Project Name
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "migrationai"
}

# Number of public subnets
variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}

# Number of private subnets
variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
  default     = 2
} 