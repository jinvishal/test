# Module: ECR resources

# --- ECR ---

resource "aws_ecr_repository" "app" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE" # or "IMMUTABLE" if you prefer

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name      = "${var.project_name}-ecr-${var.ecr_repository_name}"
    Project   = var.project_name
  }
}
