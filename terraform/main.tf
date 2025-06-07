# Terraform main configuration file

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Specify a version constraint
    }
  }
}

provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region
  # You can also configure credentials here, or via environment variables,
  # shared credentials file, or IAM roles.
  # access_key = "YOUR_ACCESS_KEY"
  # secret_key = "YOUR_SECRET_KEY"
}

# Terraform Backend Configuration (Optional - S3 Example)
# Commented out for now, uses local backend by default.
#
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket-name" # Replace with your S3 bucket name
#     key            = "project-name/terraform.tfstate"   # Replace with your state file path
#     region         = "us-east-1"                        # Replace with your S3 bucket region
#     # dynamodb_table = "your-terraform-locks-table"      # Optional: For state locking
#     # encrypt        = true                               # Optional: Enable server-side encryption
#   }
# }

module "app_infrastructure" {
  source = "./modules/app_infrastructure" # Path to the module

  # Required variables for the module that don't have defaults in the module itself
  aws_region           = var.aws_region
  availability_zones   = var.availability_zones
  project_name         = var.project_name # Pass project_name

  # You can override other module variables here if needed, for example:
  # vpc_cidr_block                 = "10.1.0.0/16"
  # ecr_repository_name            = "my-custom-app-repo"
  # my_ip_for_ssh                  = "YOUR_IP/32" # Important for security

  # Variables that will be used by AppRunner (can be set to defaults or overridden)
  # docker_image_tag = var.docker_image_tag # Assuming you want to control this from root
  # app_port = var.app_port # Assuming you want to control this from root
}
