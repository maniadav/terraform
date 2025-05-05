# IAM Role for Elastic Beanstalk
resource "aws_iam_role" "eb_instance_role" {
  name = var.eb_instance_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach managed policy to the role
resource "aws_iam_role_policy_attachment" "eb_instance_role_policy" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

# IAM Policy to allow Elastic Beanstalk to pull images from ECR
resource "aws_iam_policy" "ecr_access_policy" {
  name        = var.ecr_access_policy_name
  description = "Policy to allow Elastic Beanstalk to pull images from ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage"],
        Resource = "*"
      }
    ]
  })
}

# Attach ECR access policy to the role
resource "aws_iam_role_policy_attachment" "ecr_access_policy_attachment" {
  role       = aws_iam_role.eb_instance_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

# Instance Profile for Elastic Beanstalk
resource "aws_iam_instance_profile" "eb_instance_profile" {
  name = var.eb_instance_profile_name
  role = aws_iam_role.eb_instance_role.name
}