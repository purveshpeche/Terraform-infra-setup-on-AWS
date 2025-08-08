# AWS CodePipeline, CodeBuild, and CodeDeploy for MigrationAI



# IAM Role for CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_name}-${var.environment}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-codepipeline-role"
  }
}

# IAM Policy for CodePipeline
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.project_name}-${var.environment}-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "codedeploy:*"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "apprunner:StartDeployment"
        ]
        Resource = "*"
      }
    ]
  })
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project_name}-${var.environment}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-codebuild-role"
  }
}

# IAM Policy for CodeBuild
resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${var.project_name}-${var.environment}-codebuild-policy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# CodeBuild Project for building Docker images
resource "aws_codebuild_project" "lambda_build" {
  name          = "${var.project_name}-${var.environment}-lambda-build"
  description   = "Build Lambda Docker images"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.project_name}-${var.environment}-lambda-build"
      stream_name = "build-log"
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-lambda-build"
  }
}

# CodeDeploy Application for EC2
resource "aws_codedeploy_app" "ec2_app" {
  name = "${var.project_name}-${var.environment}-ec2-app"
  compute_platform = "Server"
}

# CodeDeploy Deployment Group for EC2
resource "aws_codedeploy_deployment_group" "ec2_deployment_group" {
  app_name               = aws_codedeploy_app.ec2_app.name
  deployment_group_name  = "${var.project_name}-${var.environment}-ec2-deployment-group"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "migrationai-backend"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

# IAM Role for CodeDeploy
resource "aws_iam_role" "codedeploy_role" {
  name = "${var.project_name}-${var.environment}-codedeploy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-codedeploy-role"
  }
}

# IAM Policy for CodeDeploy
resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy_role.name
}

# CodePipeline for CI/CD
resource "aws_codepipeline" "main" {
  name     = "${var.project_name}-${var.environment}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type = "S3"
    location = "migrationai-prod-pipeline-artifacts"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner                = "your-github-username"
        Repo                 = "migrationai-repo"
        Branch               = "main"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.lambda_build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy-EC2"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName = aws_codedeploy_app.ec2_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.ec2_deployment_group.deployment_group_name
        RevisionType = "S3"
        S3Location = "build_output"
      }
    }

    action {
      name            = "Deploy-Lambda-Contacts"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        FunctionName = "migrationai-contacts"
        UserParameters = "{\"ImageUri\":\"${aws_ecr_repository.worker_contacts.repository_url}:latest\"}"
      }
    }

    action {
      name            = "Deploy-Lambda-Projects"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "Lambda"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        FunctionName = "migrationai-projects"
        UserParameters = "{\"ImageUri\":\"${aws_ecr_repository.worker_projects.repository_url}:latest\"}"
      }
    }

    action {
      name            = "Deploy-AppRunner-Frontend"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "AppRunner"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ServiceName = "migrationai-frontend"
      }
    }

    action {
      name            = "Deploy-AppRunner-Admin"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "AppRunner"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ServiceName = "migrationai-admin-frontend"
      }
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-pipeline"
  }
}

# CloudWatch Log Group for CodeBuild
resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "/aws/codebuild/${var.project_name}-${var.environment}-lambda-build"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-${var.environment}-codebuild-logs"
  }
} 
