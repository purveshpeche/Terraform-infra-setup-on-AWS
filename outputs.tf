# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of the private subnets"
  value       = aws_subnet.private[*].cidr_block
}

# Internet Gateway Output
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# Route Table Output
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private.id
}

# NAT Gateway Outputs
output "nat_gateway_ids" {
  description = "IDs of the NAT gateways"
  value       = aws_nat_gateway.main[*].id
}

output "elastic_ip_ids" {
  description = "IDs of the Elastic IPs"
  value       = aws_eip.nat[*].id
}

# Security Group Outputs
output "backend_security_group_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.backend.id
}

output "redis_security_group_id" {
  description = "ID of the Redis security group"
  value       = aws_security_group.redis.id
}

# ECR Repository Outputs
output "ecr_repository_urls" {
  description = "URLs of all ECR repositories"
  value = {
    frontend       = aws_ecr_repository.frontend.repository_url
    admin_frontend = aws_ecr_repository.admin_frontend.repository_url
    backend_api    = aws_ecr_repository.backend_api.repository_url
    admin_backend  = aws_ecr_repository.admin_backend.repository_url
    tfp            = aws_ecr_repository.tfp.repository_url
  }
}

# S3 Bucket Output
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

# MemoryDB Outputs
output "memorydb_cluster_endpoint" {
  description = "Endpoint of the MemoryDB cluster"
  value       = aws_memorydb_cluster.redis.cluster_endpoint
}

# SQS Queue Outputs
output "sqs_queue_urls" {
  description = "URLs of all SQS queues"
  value = {
    contacts        = aws_sqs_queue.contacts.url
    projects        = aws_sqs_queue.projects.url
    sections        = aws_sqs_queue.sections.url
    notes           = aws_sqs_queue.notes.url
    calendar        = aws_sqs_queue.calendar.url
    tasks           = aws_sqs_queue.tasks.url
    billing_items   = aws_sqs_queue.billing_items.url
    project_funds   = aws_sqs_queue.project_funds.url
    billing_invoice = aws_sqs_queue.billing_invoice.url
    payment         = aws_sqs_queue.payment.url
    project_email   = aws_sqs_queue.project_email.url
    document        = aws_sqs_queue.document.url
    jobs            = aws_sqs_queue.jobs.url
  }
}

# Lambda Function Outputs
output "lambda_function_names" {
  description = "Names of all Lambda functions"
  value = [
    aws_lambda_function.contacts.function_name,
    aws_lambda_function.projects.function_name,
    aws_lambda_function.sections.function_name,
    aws_lambda_function.notes.function_name,
    aws_lambda_function.calendar.function_name,
    aws_lambda_function.tasks.function_name,
    aws_lambda_function.billing_items.function_name,
    aws_lambda_function.project_funds.function_name,
    aws_lambda_function.billing_invoice.function_name,
    aws_lambda_function.payment.function_name,
    aws_lambda_function.project_email.function_name,
    aws_lambda_function.document.function_name,
    aws_lambda_function.jobs.function_name
  ]
}

# EC2 Instance Outputs
output "ec2_instance_ids" {
  description = "IDs of the EC2 instances"
  value = {
    backend = aws_instance.backend.id
    tfp     = aws_instance.tfp.id
  }
}

output "ec2_instance_private_ips" {
  description = "Private IPs of the EC2 instances"
  value = {
    backend = aws_instance.backend.private_ip
    tfp     = aws_instance.tfp.private_ip
  }
}

# App Runner Outputs
output "apprunner_service_urls" {
  description = "URLs of the App Runner services"
  value = {
    frontend       = aws_apprunner_service.frontend.service_url
    admin_frontend = aws_apprunner_service.admin_frontend.service_url
  }
}

# EC2 Connection Commands
output "ec2_connection_command_backend" {
  description = "Command to connect to backend EC2 instance via Systems Manager"
  value       = "aws ssm start-session --target ${aws_instance.backend.id}"
}

output "ec2_connection_command_tfp" {
  description = "Command to connect to TFP EC2 instance via Systems Manager"
  value       = "aws ssm start-session --target ${aws_instance.tfp.id}"
}

# CodePipeline Outputs
output "codepipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.main.name
}

output "codebuild_project_name" {
  description = "Name of the CodeBuild project"
  value       = aws_codebuild_project.lambda_build.name
} 