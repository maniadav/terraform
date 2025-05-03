output "elastic_beanstalk_env_url" {
  description = "The URL of the Elastic Beanstalk environment."
  value       = aws_elastic_beanstalk_environment.backend_env.endpoint_url
}

output "elastic_beanstalk_env_cname" {
  description = "The CNAME of the Elastic Beanstalk environment."
  value       = aws_elastic_beanstalk_environment.backend_env.cname
}