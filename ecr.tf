# ECR Repositories for MigrationAI

# Frontend Containers
resource "aws_ecr_repository" "frontend" {
  name                 = "prod/migrationai-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-frontend"
  }
}

resource "aws_ecr_repository" "admin_frontend" {
  name                 = "prod/migrationai-admin-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-admin-frontend"
  }
}

# Backend Containers
resource "aws_ecr_repository" "backend_api" {
  name                 = "prod/migrationai-backend-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-api"
  }
}

resource "aws_ecr_repository" "admin_backend" {
  name                 = "prod/migrationai-admin-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-admin-backend"
  }
}

resource "aws_ecr_repository" "tfp" {
  name                 = "prod/migrationai-tfp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-tfp"
  }
}

# Worker Containers
resource "aws_ecr_repository" "worker_contacts" {
  name                 = "prod/migrationai-backend-worker-contacts"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-contacts"
  }
}

resource "aws_ecr_repository" "worker_projects" {
  name                 = "prod/migrationai-backend-worker-projects"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-projects"
  }
}

resource "aws_ecr_repository" "worker_sections" {
  name                 = "prod/migrationai-backend-worker-sections"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-sections"
  }
}

resource "aws_ecr_repository" "worker_notes" {
  name                 = "prod/migrationai-backend-worker-notes"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-notes"
  }
}

resource "aws_ecr_repository" "worker_calendar" {
  name                 = "prod/migrationai-backend-worker-calendar"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-calendar"
  }
}

resource "aws_ecr_repository" "worker_tasks" {
  name                 = "prod/migrationai-backend-worker-tasks"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-tasks"
  }
}

resource "aws_ecr_repository" "worker_billing_items" {
  name                 = "prod/migrationai-backend-worker-billing-items"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-billing-items"
  }
}

resource "aws_ecr_repository" "worker_project_funds" {
  name                 = "prod/migrationai-backend-worker-project-funds"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-project-funds"
  }
}

resource "aws_ecr_repository" "worker_billing_invoice" {
  name                 = "prod/migrationai-backend-worker-billing-invoice"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-billing-invoice"
  }
}

resource "aws_ecr_repository" "worker_payment" {
  name                 = "prod/migrationai-backend-worker-payment"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-payment"
  }
}

resource "aws_ecr_repository" "worker_project_email" {
  name                 = "prod/migrationai-backend-worker-project-email"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-project-email"
  }
}

resource "aws_ecr_repository" "worker_document" {
  name                 = "prod/migrationai-backend-worker-document"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-document"
  }
}

resource "aws_ecr_repository" "worker_jobs" {
  name                 = "prod/migrationai-backend-worker-jobs"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "prod/migrationai-backend-worker-jobs"
  }
} 