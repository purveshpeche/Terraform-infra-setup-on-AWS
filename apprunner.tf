# App Runner Services for MigrationAI

# IAM Role for App Runner
resource "aws_iam_role" "apprunner_role" {
  name = "${var.project_name}-${var.environment}-apprunner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-apprunner-role"
  }
}

# IAM Policy for App Runner
resource "aws_iam_role_policy" "apprunner_policy" {
  name = "${var.project_name}-${var.environment}-apprunner-policy"
  role = aws_iam_role.apprunner_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# App Runner Service for Frontend
resource "aws_apprunner_service" "frontend" {
  service_name = "migrationai-frontend"

  source_configuration {
    image_repository {
      image_configuration {
        port = "3000"
      }
      image_identifier      = "${aws_ecr_repository.frontend.repository_url}:latest"
      image_repository_type = "ECR"
    }
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_role.arn
  }

  network_configuration {
    egress_configuration {
      egress_type = "DEFAULT"
    }
  }

  tags = {
    Name = "migrationai-frontend"
  }
}

# App Runner Service for Admin Frontend
resource "aws_apprunner_service" "admin_frontend" {
  service_name = "migrationai-admin-frontend"

  source_configuration {
    image_repository {
      image_configuration {
        port = "3000"
      }
      image_identifier      = "${aws_ecr_repository.admin_frontend.repository_url}:latest"
      image_repository_type = "ECR"
    }
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner_role.arn
  }

  network_configuration {
    egress_configuration {
      egress_type = "DEFAULT"
    }
  }

  tags = {
    Name = "migrationai-admin-frontend"
  }
} 