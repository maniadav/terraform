# AWS Terraform Modules

This directory contains Terraform modules for deploying resources on AWS. The subdirectories are organized by resource type.

## Subdirectories

- **ec2/**: Contains Terraform configurations for deploying EC2 instances.
- **elastic-beanstalk/**: Contains Terraform configurations for deploying Elastic Beanstalk environments.

## Deployment Steps

1. Navigate to the desired subdirectory (e.g., `elastic-beanstalk/`).
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Validate the configuration:
   ```bash
   terraform validate
   ```
4. Plan the deployment:
   ```bash
   terraform plan
   ```
5. Apply the deployment:
   ```bash
   terraform apply
   ```
6. To destroy the resources:
   ```bash
   terraform destroy
   ```