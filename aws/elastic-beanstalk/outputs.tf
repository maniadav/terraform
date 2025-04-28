output "ecr_repository_url" {
  description = "ECR repository URL where docker images will be pushed"
  value       = aws_ecr_repository.backend_repo.repository_url
}

output "beanstalk_environment_url" {
  description = "Elastic Beanstalk environment URL"
  value       = aws_elastic_beanstalk_environment.backend_env.endpoint_url
}
