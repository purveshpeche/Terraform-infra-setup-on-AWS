# Lambda Functions for MigrationAI Workers (Dockerized)

# IAM Role for Lambda Functions
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-${var.environment}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-lambda-role"
  }
}

# IAM Policy for Lambda Functions
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_name}-${var.environment}-lambda-policy"
  role = aws_iam_role.lambda_role.id

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
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = [
          aws_sqs_queue.contacts.arn,
          aws_sqs_queue.projects.arn,
          aws_sqs_queue.sections.arn,
          aws_sqs_queue.notes.arn,
          aws_sqs_queue.calendar.arn,
          aws_sqs_queue.tasks.arn,
          aws_sqs_queue.billing_items.arn,
          aws_sqs_queue.project_funds.arn,
          aws_sqs_queue.billing_invoice.arn,
          aws_sqs_queue.payment.arn,
          aws_sqs_queue.project_email.arn,
          aws_sqs_queue.document.arn,
          aws_sqs_queue.jobs.arn
        ]
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
      }
    ]
  })
}

# Lambda Functions (Dockerized)
resource "aws_lambda_function" "contacts" {
  function_name = "migrationai-contacts"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_contacts.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.contacts.url
    }
  }

  tags = {
    Name = "migrationai-contacts"
  }
}

resource "aws_lambda_function" "projects" {
  function_name = "migrationai-projects"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_projects.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.projects.url
    }
  }

  tags = {
    Name = "migrationai-projects"
  }
}

resource "aws_lambda_function" "sections" {
  function_name = "migrationai-sections"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_sections.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.sections.url
    }
  }

  tags = {
    Name = "migrationai-sections"
  }
}

resource "aws_lambda_function" "notes" {
  function_name = "migrationai-notes"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_notes.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.notes.url
    }
  }

  tags = {
    Name = "migrationai-notes"
  }
}

resource "aws_lambda_function" "calendar" {
  function_name = "migrationai-calendar"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_calendar.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.calendar.url
    }
  }

  tags = {
    Name = "migrationai-calendar"
  }
}

resource "aws_lambda_function" "tasks" {
  function_name = "migrationai-tasks"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_tasks.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.tasks.url
    }
  }

  tags = {
    Name = "migrationai-tasks"
  }
}

resource "aws_lambda_function" "billing_items" {
  function_name = "migrationai-billing-items"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_billing_items.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.billing_items.url
    }
  }

  tags = {
    Name = "migrationai-billing-items"
  }
}

resource "aws_lambda_function" "project_funds" {
  function_name = "migrationai-project-funds"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_project_funds.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.project_funds.url
    }
  }

  tags = {
    Name = "migrationai-project-funds"
  }
}

resource "aws_lambda_function" "billing_invoice" {
  function_name = "migrationai-billing-invoice"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_billing_invoice.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.billing_invoice.url
    }
  }

  tags = {
    Name = "migrationai-billing-invoice"
  }
}

resource "aws_lambda_function" "payment" {
  function_name = "migrationai-payment"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_payment.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.payment.url
    }
  }

  tags = {
    Name = "migrationai-payment"
  }
}

resource "aws_lambda_function" "project_email" {
  function_name = "migrationai-project-email"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_project_email.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.project_email.url
    }
  }

  tags = {
    Name = "migrationai-project-email"
  }
}

resource "aws_lambda_function" "document" {
  function_name = "migrationai-document"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_document.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.document.url
    }
  }

  tags = {
    Name = "migrationai-document"
  }
}

resource "aws_lambda_function" "jobs" {
  function_name = "migrationai-jobs"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.worker_jobs.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 300
  memory_size   = 512

  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.jobs.url
    }
  }

  tags = {
    Name = "migrationai-jobs"
  }
}

# SQS Event Source Mappings for Lambda Triggers
resource "aws_lambda_event_source_mapping" "contacts_trigger" {
  event_source_arn = aws_sqs_queue.contacts.arn
  function_name    = aws_lambda_function.contacts.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "projects_trigger" {
  event_source_arn = aws_sqs_queue.projects.arn
  function_name    = aws_lambda_function.projects.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "sections_trigger" {
  event_source_arn = aws_sqs_queue.sections.arn
  function_name    = aws_lambda_function.sections.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "notes_trigger" {
  event_source_arn = aws_sqs_queue.notes.arn
  function_name    = aws_lambda_function.notes.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "calendar_trigger" {
  event_source_arn = aws_sqs_queue.calendar.arn
  function_name    = aws_lambda_function.calendar.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "tasks_trigger" {
  event_source_arn = aws_sqs_queue.tasks.arn
  function_name    = aws_lambda_function.tasks.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "billing_items_trigger" {
  event_source_arn = aws_sqs_queue.billing_items.arn
  function_name    = aws_lambda_function.billing_items.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "project_funds_trigger" {
  event_source_arn = aws_sqs_queue.project_funds.arn
  function_name    = aws_lambda_function.project_funds.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "billing_invoice_trigger" {
  event_source_arn = aws_sqs_queue.billing_invoice.arn
  function_name    = aws_lambda_function.billing_invoice.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "payment_trigger" {
  event_source_arn = aws_sqs_queue.payment.arn
  function_name    = aws_lambda_function.payment.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "project_email_trigger" {
  event_source_arn = aws_sqs_queue.project_email.arn
  function_name    = aws_lambda_function.project_email.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "document_trigger" {
  event_source_arn = aws_sqs_queue.document.arn
  function_name    = aws_lambda_function.document.arn
  enabled          = true
}

resource "aws_lambda_event_source_mapping" "jobs_trigger" {
  event_source_arn = aws_sqs_queue.jobs.arn
  function_name    = aws_lambda_function.jobs.arn
  enabled          = true
} 