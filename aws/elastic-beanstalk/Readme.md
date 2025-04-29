# Elastic Beanstalk Terraform Module

This directory contains Terraform configurations for deploying an Elastic Beanstalk environment on AWS.

## Files

- **main.tf**: Defines the Elastic Beanstalk application and environment.
- **iam.tf**: Manages IAM roles and instance profiles required for Elastic Beanstalk.
- **variables.tf**: Contains input variables for the module.
- **outputs.tf**: Defines the outputs of the module.
- **provider.tf**: Configures the AWS provider.
- **Dockerrun.aws.json**: Specifies the Docker image and container configuration for the Elastic Beanstalk environment.

## Deployment Steps

1. Initialize Terraform:
   ```bash
   terraform init
   ```
2. Validate the configuration:
   ```bash
   terraform validate
   ```
3. Plan the deployment:
   ```bash
   terraform plan
   ```
4. Apply the deployment:
   ```bash
   terraform apply
   ```
5. To destroy the resources:
   ```bash
   terraform destroy
   ```
