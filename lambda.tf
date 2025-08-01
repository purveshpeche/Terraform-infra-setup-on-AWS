# Lambda Functions for MigrationAI Workers

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
      }
    ]
  })
}

# Lambda Functions
resource "aws_lambda_function" "contacts" {
  filename      = "lambda_contacts.zip"
  function_name = "migrationai-contacts"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_projects.zip"
  function_name = "migrationai-projects"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_sections.zip"
  function_name = "migrationai-sections"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_notes.zip"
  function_name = "migrationai-notes"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_calendar.zip"
  function_name = "migrationai-calendar"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_tasks.zip"
  function_name = "migrationai-tasks"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_billing_items.zip"
  function_name = "migrationai-billing-items"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_project_funds.zip"
  function_name = "migrationai-project-funds"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_billing_invoice.zip"
  function_name = "migrationai-billing-invoice"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_payment.zip"
  function_name = "migrationai-payment"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_project_email.zip"
  function_name = "migrationai-project-email"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_document.zip"
  function_name = "migrationai-document"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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
  filename      = "lambda_jobs.zip"
  function_name = "migrationai-jobs"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
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