# Module: Input Variables

variable "apprunner_service_name_suffix" {
  description = "Suffix for the App Runner service name. Full name will be ${var.project_name}-app-service-${var.apprunner_service_name_suffix}"
  type        = string
  default     = "live"
}

variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  # No default here, should be provided by the root module or have a default in root.
  # For now, let root module define it.
}

variable "project_name" {
  description = "A name for the project, used for tagging resources"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_az1_cidr_block" {
  description = "CIDR block for the public subnet in AZ1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az2_cidr_block" {
  description = "CIDR block for the public subnet in AZ2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_az1_cidr_block" {
  description = "CIDR block for the private subnet in AZ1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_az2_cidr_block" {
  description = "CIDR block for the private subnet in AZ2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  # Default provided as an example, should be configurable based on region
  # default     = ["us-east-1a", "us-east-1b"]
}

variable "my_ip_for_ssh" {
  description = "Your IP address (CIDR format, e.g., x.x.x.x/32) for SSH access to EC2 instances"
  type        = string
  default     = "0.0.0.0/0" # WARNING: This allows SSH from anywhere. Replace with your specific IP in production.
}

variable "ecr_repository_name" {
  description = "Name for the ECR repository"
  type        = string
  default     = "slither-io-clone-app" # Default ECR repo name
}

# EC2/ASG variables - will be re-evaluated when AppRunner is added
variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instances (e.g., Amazon Linux 2)"
  type        = string
  default     = "ami-0cff7528ff583bf9a"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "docker_image_tag" {
  description = "Docker image tag to deploy (e.g., 'latest' or a specific version)"
  type        = string
  default     = "latest"
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "app_port" {
  description = "Port the application inside the container listens on"
  type        = number
  default     = 3000
}
