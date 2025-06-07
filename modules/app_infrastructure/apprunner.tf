# Module: App Runner resources

# IAM Role for App Runner to access ECR
resource "aws_iam_role" "apprunner_ecr_access" {
  name = "${var.project_name}-apprunner-ecr-access-role"

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
    Name    = "${var.project_name}-apprunner-ecr-role"
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_policy_attachment" {
  role       = aws_iam_role.apprunner_ecr_access.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

# AWS App Runner Service
resource "aws_apprunner_service" "main" {
  service_name = "${var.project_name}-app-service-${var.apprunner_service_name_suffix}" # Consider making this a variable

  source_configuration {
    image_repository {
      image_identifier      = "${aws_ecr_repository.app.repository_url}:${var.docker_image_tag}" # ECR image URI
      image_repository_type = "ECR"
      image_configuration {
        port = var.app_port # Port your application listens on
      }
    }
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }
    auto_deployments_enabled = true # Optional: enable auto deployments on image push
  }

  # instance_configuration { # Optional: configure CPU and Memory
  #   cpu    = "1024" # 1 vCPU
  #   memory = "2048" # 2 GB
  # }

  tags = {
    Name    = "${var.project_name}-app-runner-service"
    Project = var.project_name
  }

  # Network configuration can be added here if VPC integration is needed.
  # For now, App Runner will use its managed VPC.
  # network_configuration {
  #   egress_configuration {
  #     egress_type = "VPC" # or "DEFAULT"
  #     vpc_connector_arn = aws_apprunner_vpc_connector.main.arn # If using VPC connector
  #   }
  # }
}
