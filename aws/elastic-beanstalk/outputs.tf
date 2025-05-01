output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.backend_repo.repository_url
}

output "elastic_beanstalk_application_name" {
  description = "The name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.backend_app.name
}

output "elastic_beanstalk_environment_name" {
  description = "The name of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.backend_env.name
}

output "elastic_beanstalk_environment_endpoint" {
  description = "The endpoint URL of the Elastic Beanstalk environment"
  value       = aws_elastic_beanstalk_environment.backend_env.endpoint_url
}

output "app_version" {
  description = "The current version of the application"
  value       = local.version_name
}

output "iam_role_names" {
  description = "Names of the IAM roles created"
  value = {
    instance_role = aws_iam_role.eb_instance_role.name
    service_role  = aws_iam_role.eb_service_role.name
  }
}
