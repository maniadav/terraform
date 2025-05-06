variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "app_name" {
  description = "Elastic Beanstalk application name"
  type        = string
  default     = "flask-eb"
}

variable "env_name" {
  description = "Elastic Beanstalk environment name"
  type        = string
  default     = "flask-eb-env"
}

variable "ecr_repo_name" {
  description = "ECR repository to store docker image"
  type        = string
  default     = "flask-eb-ecr"
}

variable "eb_service_role_name" {
  description = "Name of the Elastic Beanstalk service role"
  type        = string
  default     = "flask-eb-service-role"
}

variable "eb_instance_role_name" {
  description = "Name of the Elastic Beanstalk instance role"
  type        = string
  default     = "flask-eb-instance-role"
}

variable "eb_instance_profile_name" {
  description = "Name of the Elastic Beanstalk instance profile"
  type        = string
  default     = "flask-eb-instance-profile"
}

variable "ecr_lifecycle_policy" {
  description = "Lifecycle policy for ECR repository to enable auto versioning."
  type        = string
  default     = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images after 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT
}

variable "ecr_access_policy_name" {
  description = "Name of the ECR access policy."
  type        = string
  default     = "flask-eb-ecr-access-policy"
}

variable "app_version" {
  description = "Version of the application to deploy. If not provided, a default version will be generated."
  type        = string
  default     = ""
}
