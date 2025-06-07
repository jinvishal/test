# Terraform root input variables

variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "A name for the project, used for tagging resources and naming module resources"
  type        = string
  default     = "slither-io-clone"
}

variable "availability_zones" {
  description = "List of availability zones to use for the module"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"] # Ensure these are valid for your chosen region
}

variable "my_ip_for_ssh" {
  description = "Your IP address (CIDR format, e.g., x.x.x.x/32) for any SSH access (e.g., bastion host if added later). Default allows from anywhere."
  type        = string
  default     = "0.0.0.0/0" # WARNING: This allows SSH from anywhere. Replace with your specific IP.
  # This variable is passed to the module, which might use it for security groups.
}

variable "docker_image_tag" {
  description = "Docker image tag to deploy (e.g., 'latest' or a specific version)"
  type        = string
  default     = "latest"
  # This variable can be passed to the module to specify the image for App Runner.
}

variable "app_port" {
  description = "Port the application inside the container listens on. Will be used by App Runner."
  type        = number
  default     = 3000
  # This variable can be passed to the module for App Runner configuration.
}

# Other variables like VPC CIDRs, subnet CIDRs, ECR name,
# and specific EC2/ASG variables are now managed within the module
# or will be replaced by AppRunner specific configurations.
# They are removed from here to simplify root module inputs.
# If you need to override module defaults for these,
# you can expose them as variables here and pass them to the module block in main.tf.
