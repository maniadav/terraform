variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "app_name" {
  description = "Elastic Beanstalk application name"
  type        = string
  default     = "flask_eb_app"
}

variable "env_name" {
  description = "Elastic Beanstalk environment name"
  type        = string
  default     = "flask_eb_env"
}

variable "ecr_repo_name" {
  description = "ECR repository to store docker image"
  type        = string
  default     = "flask_eb_ecr"
}

variable "eb_service_role_name" {
  description = "Name of the Elastic Beanstalk service role"
  type        = string
  default     = "flask_eb_service_role"
}

variable "eb_instance_role_name" {
  description = "Name of the Elastic Beanstalk instance role"
  type        = string
  default     = "flask_eb_instance_role"
}

variable "eb_instance_profile_name" {
  description = "Name of the Elastic Beanstalk instance profile"
  type        = string
  default     = "flask_eb_instance_profile"
}
