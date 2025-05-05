output "elastic_beanstalk_env_url" {
  description = "The URL of the Elastic Beanstalk environment."
  value       = aws_elastic_beanstalk_environment.backend_env.endpoint_url
}

output "elastic_beanstalk_env_cname" {
  description = "The CNAME of the Elastic Beanstalk environment."
  value       = aws_elastic_beanstalk_environment.backend_env.cname
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository."
  value       = aws_ecr_repository.backend_repo.repository_url
}

output "ecr_image_version" {
  description = "The version of the ECR image."
  value       = "flask-eb-2025-05-03"
}