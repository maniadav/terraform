# Terraform Basics and Configuration Guide

## Introduction

Terraform is an open-source Infrastructure as Code (IaC) tool that allows you to define and provision infrastructure using a high-level configuration language. This guide will help you understand the basics of Terraform and how to get started with the configurations in this project.

---

## Prerequisites

Before working with Terraform, ensure you have the following installed:

1. **Terraform CLI**: Download and install Terraform from [Terraform Downloads](https://www.terraform.io/downloads).
2. **AWS CLI** (if working with AWS): Install the AWS CLI from [AWS CLI Installation](https://aws.amazon.com/cli/).
3. **Azure CLI** (if working with Azure): Install the Azure CLI from [Azure CLI Installation](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
4. **GCP CLI** (if working with GCP): Install the GCP CLI from [GCP CLI Installation](https://cloud.google.com/sdk/docs/install).

---

## Project Structure

The project is organized into the following directories:

- **aws/**: Contains Terraform configurations for AWS resources.

  - **ec2/**: Configuration for EC2 instances.
  - **elastic-beanstalk/**: Configuration for Elastic Beanstalk applications.
    - `main.tf`: Contains the main resource definitions.
    - `outputs.tf`: Defines the outputs of the Terraform configuration.
    - `provider.tf`: Configures the provider (e.g., AWS).
    - `variables.tf`: Defines input variables for the configuration.
    - `Readme.md`: Documentation for the Elastic Beanstalk configuration.
- **azure/**: Contains Terraform configurations for Azure resources.
- **gcp/**: Contains Terraform configurations for GCP resources.

---

## Getting Started with Terraform

### 1. Initialize the Project

Run the following command in the directory containing your Terraform configuration files (e.g., `elastic-beanstalk/`):

```bash
terraform init
```

This initializes the project and downloads the necessary provider plugins.

### 2. Validate the Configuration

To ensure your configuration files are syntactically valid, run:

```bash
terraform validate
```

### 3. Plan the Infrastructure

Generate an execution plan to see what changes Terraform will make:

```bash
terraform plan
```

### 4. Apply the Configuration

Apply the changes to provision the infrastructure:

```bash
terraform apply
```

### 5. Destroy the Infrastructure

To destroy the resources created by Terraform, run:

```bash
terraform destroy
```

---

## Key Concepts

### Providers

Providers are plugins that allow Terraform to interact with cloud providers, SaaS providers, and other APIs. Example:

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

### Resources

Resources are the most important element in the Terraform language. They describe one or more infrastructure objects. Example:

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

### Variables

Variables allow you to parameterize your configurations. Example:

```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

### Outputs

Outputs allow you to extract information about your resources. Example:

```hcl
output "instance_id" {
  value = aws_instance.example.id
}
```

---

## Configuring Cloud Providers

### AWS Configuration

1. Install the AWS CLI and configure it:

   ```bash
   aws configure
   ```

   Provide your AWS Access Key ID, Secret Access Key, default region, and output format.
2. Create an IAM user in AWS with the following steps:

   - Go to the AWS Management Console > IAM > Users.
   - Create a new user with programmatic access.
   - Attach the `TerraformFullAccess` policy (or a custom policy with necessary permissions).
   - ```
     {
       "Version": "2012-10-17",
       "Statement": [
         {
           "Effect": "Allow",
           "Action": [
             "ec2:*",
             "s3:*",
             "rds:*",
             "cloudwatch:*",
             "elasticbeanstalk:*",
             "autoscaling:*",
             "iam:PassRole"
           ],
           "Resource": "*"
         },
         {
           "Effect": "Deny",
           "Action": [
             "iam:DeleteUser",
             "iam:DeleteRole",
             "iam:DeletePolicy",
             "iam:DeleteAccessKey"
           ],
           "Resource": "*"
         }
       ]
     }
     ```
3. In your Terraform configuration, define the AWS provider:

   ```hcl
   provider "aws" {
     region = "ap-south-1" # Replace with your desired region
   }
   ```

### Azure Configuration

1. Install the Azure CLI and log in:

   ```bash
   az login
   ```
2. Set the subscription you want to use:

   ```bash
   az account set --subscription "<subscription-id>"
   ```
3. In your Terraform configuration, define the Azure provider:

   ```hcl
   provider "azurerm" {
     features {}
   }
   ```

### GCP Configuration

1. Install the GCP CLI and authenticate:

   ```bash
   gcloud auth login
   ```
2. Set the project you want to use:

   ```bash
   gcloud config set project <project-id>
   ```
3. In your Terraform configuration, define the GCP provider:

   ```hcl
   provider "google" {
     project = "<project-id>"
     region  = "us-central1" # Replace with your desired region
   }
   ```

---

## Best Practices

1. **Use Version Control**: Store your Terraform configurations in a version control system like Git.
2. **State Management**: Use remote state storage (e.g., S3 for AWS) to share state files across teams.
3. **Modularize Configurations**: Break down your configurations into reusable modules.
4. **Use Workspaces**: Use Terraform workspaces to manage multiple environments (e.g., dev, staging, prod).
5. **Secure Secrets**: Avoid hardcoding sensitive information. Use tools like AWS Secrets Manager or HashiCorp Vault.

---

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

---

Happy Terraforming!
