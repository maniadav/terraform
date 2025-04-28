variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Elastic Beanstalk application name"
  type        = string
  default     = "backend-elastic-beanstalk-app"
}

variable "env_name" {
  description = "Elastic Beanstalk environment name"
  type        = string
  default     = "backend-elastic-beanstalk-env"
}

variable "ecr_repo_name" {
  description = "ECR repository to store docker image"
  type        = string
  default     = "backend-elastic-beanstalk-ecr"
}
