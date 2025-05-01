# Elastic Beanstalk Terraform Module

This directory contains Terraform configurations for deploying an Elastic Beanstalk environment on AWS.

## State Management Setup

This project uses AWS S3 for storing Terraform state files and DynamoDB for state locking. There are two possible scenarios when you clone this repository:

### Scenario 1: Existing Project with State in AWS

If you're joining an existing project where infrastructure is already deployed:

1. Ensure you have AWS credentials with appropriate permissions:
   ```bash
   aws configure
   ```
   Required permissions:
   - S3 full access for state management
   - DynamoDB full access for state locking
   - Elastic Beanstalk full access
   - IAM permissions for creating roles

2. Initialize Terraform to download the existing state:
   ```bash
   terraform init
   ```
   This will automatically:
   - Configure the S3 backend
   - Download the existing state from S3
   - Set up state locking with DynamoDB

3. You can now manage the infrastructure:
   ```bash
   terraform plan     # Check planned changes
   terraform destroy  # Destroy resources if needed
   ```

### Scenario 2: New Project Setup

If this is a fresh deployment with no existing infrastructure:

1. First, create the backend infrastructure:
   ```bash
   cd backend-setup
   terraform init
   terraform apply
   ```
   This creates:
   - S3 bucket for state storage
   - DynamoDB table for state locking

2. Return to the main directory and initialize Terraform:
   ```bash
   cd ..
   terraform init
   ```

3. Now you can deploy the infrastructure:
   ```bash
   terraform plan
   terraform apply
   ```

## Verifying State Status

To check if there's existing state in AWS:

1. Check if the S3 bucket exists:
   ```bash
   aws s3 ls s3://terraform-state-backend-elastic-beanstalk
   ```

2. Check for existing state file:
   ```bash
   aws s3 ls s3://terraform-state-backend-elastic-beanstalk/elastic-beanstalk/terraform.tfstate
   ```

If these commands return results, you're in Scenario 1 (existing state). If they return "NoSuchBucket" or no results, you're in Scenario 2 (new project).

## Getting Started After Cloning

1. Ensure you have AWS credentials configured with appropriate permissions:
   ```bash
   aws configure
   ```
   Required permissions:
   - S3 full access for state management
   - DynamoDB full access for state locking
   - Elastic Beanstalk full access
   - IAM permissions for creating roles

2. You can now run Terraform commands normally:
   ```bash
   terraform plan    # Preview changes
   terraform apply   # Apply changes
   terraform destroy # Destroy resources
   ```

## State Management Details

The state management setup includes:

1. **S3 Backend**: 
   - Bucket: terraform-state-backend-elastic-beanstalk
   - State file path: elastic-beanstalk/terraform.tfstate
   - Encryption enabled
   - Versioning enabled
   - Public access blocked

2. **State Locking**: 
   - DynamoDB table: terraform-state-lock
   - Prevents concurrent modifications
   - Ensures team collaboration safety

## Files

- **main.tf**: Defines the Elastic Beanstalk application and environment.
- **iam.tf**: Manages IAM roles and instance profiles required for Elastic Beanstalk.
- **variables.tf**: Contains input variables for the module.
- **outputs.tf**: Defines the outputs of the module.
- **provider.tf**: Configures the AWS provider and S3 backend.
- **backend.tf**: Defines S3 bucket and DynamoDB table for state management.

## Troubleshooting

If you encounter state-related issues:
1. Check AWS credentials have S3 and DynamoDB permissions
2. Verify you're in the correct AWS region
3. Run `terraform init -reconfigure` if backend configuration changed

If import fails:
1. Check AWS credentials have proper permissions
2. Verify resources exist in specified region
3. Ensure resource names match your AWS configuration

To check existing resources in AWS:
```bash
# List all Elastic Beanstalk resources
aws elasticbeanstalk describe-applications
aws elasticbeanstalk describe-environments

# List ECR repositories
aws ecr describe-repositories
```

## General Deployment Steps

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
