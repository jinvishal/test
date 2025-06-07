# Module: Output Values

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value       = [aws_subnet.private_az1.id, aws_subnet.private_az2.id]
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.app.repository_url
}

# Add more outputs as needed, e.g., NAT gateway IPs, etc.

output "apprunner_service_id" {
  description = "The ID of the App Runner service"
  value       = aws_apprunner_service.main.service_id
}

output "apprunner_service_url" {
  description = "The default domain name/URL of the App Runner service"
  value       = aws_apprunner_service.main.service_url
}

output "apprunner_service_status" {
  description = "The current status of the App Runner service"
  value       = aws_apprunner_service.main.status
}
