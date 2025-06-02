# Backend Code Deployment on AWS

This directory provides guidance and Terraform examples for deploying backend code (assumed to be hosted on GitHub) to various AWS services. Each subdirectory here demonstrates a different deployment approach using AWS infrastructure-as-code best practices.

## How to Use

1. Ensure your backend code is available in a GitHub repository.
2. Choose the AWS service that fits your use case (e.g., EC2, Elastic Beanstalk, Lambda, ECS, EKS, App Runner, Lightsail).
3. Navigate to the relevant subdirectory for that service.
4. Update the Terraform variables to point to your GitHub repository and configure any required settings.
5. Follow the provided instructions to deploy your backend code to AWS.

## Deployment Options Covered

- **EC2**: Deploy backend code to virtual servers for maximum control.
- **Elastic Beanstalk**: Simplified deployment and management of web applications.
- **Lambda**: Serverless deployment for event-driven or API-based backends.
- **ECS**: Containerized backend deployment using Docker and managed orchestration.
- **EKS**: Kubernetes-based deployment for advanced container orchestration.
- **App Runner**: Fast deployment of containerized web apps and APIs.
- **Lightsail**: Simple VPS-based deployment for small projects or prototypes.

Each approach is demonstrated in its own subdirectory with example Terraform code and configuration tips.
