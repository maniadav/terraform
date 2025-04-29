# Create ECR Repository
resource "aws_ecr_repository" "backend_repo" {
  name = var.ecr_repo_name
}

# Create Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "backend_app" {
  name        = var.app_name
  description = "Elastic Beanstalk Application for backend API using Docker"
}

# Add missing Elastic Beanstalk requirements

# Ensure the Elastic Beanstalk environment has a Service Role
resource "aws_iam_role" "eb_service_role" {
  name = "elastic_beanstalk_service_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eb_service_role_policy" {
  role       = aws_iam_role.eb_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

# Create Elastic Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "backend_env" {
  name                = var.env_name
  application         = aws_elastic_beanstalk_application.backend_app.name
  solution_stack_name = "64bit Amazon Linux 2 v4.1.1 running Docker"
  wait_for_ready_timeout = "5m"  # Increase timeout to allow more retries

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"  # or "SingleInstance" if you want cheaper
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = "5000"  # Ensure the PORT value is properly defined
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.eb_service_role.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.eb_instance_profile.name
  }
}
