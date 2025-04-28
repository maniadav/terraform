# Create ECR Repository
resource "aws_ecr_repository" "backend_repo" {
  name = var.ecr_repo_name
}

# Create Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "backend_app" {
  name        = var.app_name
  description = "Elastic Beanstalk Application for backend API using Docker"
}

# Create Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "backend_env" {
  name                = var.env_name
  application         = aws_elastic_beanstalk_application.backend_app.name
  solution_stack_name = "64bit Amazon Linux 2 v5.8.4 running Docker"

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"  # or "SingleInstance" if you want cheaper
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = "5000"
  }

  setting {
    namespace = "aws:elasticbeanstalk:container:docker"
    name      = "Image"
    value     = aws_ecr_repository.backend_repo.repository_url
  }
}
