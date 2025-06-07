# Terraform root output values

output "ecr_repository_url" {
  description = "URL of the ECR repository created by the app_infrastructure module"
  value       = module.app_infrastructure.ecr_repository_url
}

output "vpc_id" {
  description = "ID of the VPC created by the app_infrastructure module"
  value       = module.app_infrastructure.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets created by the app_infrastructure module"
  value       = module.app_infrastructure.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets created by the app_infrastructure module"
  value       = module.app_infrastructure.private_subnet_ids
}

# More outputs will be added here, especially for App Runner service details.
