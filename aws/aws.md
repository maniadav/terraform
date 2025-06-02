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

## Deployment on AWS

There are several ways to deploy backend code on AWS, each with its own pricing model. Below is a summary of the most common deployment options:

| Deployment Method                    | Description                                                                    | Estimate Price/Month\*              |
| ------------------------------------ | ------------------------------------------------------------------------------ | ----------------------------------- |
| **EC2 (Elastic Compute Cloud)**      | Virtual servers to run any backend code. Full control over OS and environment. | ~$8 (t4g.nano, 24/7)                |
| **Elastic Beanstalk**                | Platform-as-a-Service for easy deployment and scaling of web apps.             | ~$10+ (t3.micro, 24/7)              |
| **Lambda (Serverless)**              | Run code in response to events without managing servers.                       | ~$1–$5 (1M req, 128MB, light usage) |
| **ECS (Elastic Container Service)**  | Run and manage Docker containers at scale.                                     | ~$15+ (Fargate, 1 vCPU, 2GB, 24/7)  |
| **EKS (Elastic Kubernetes Service)** | Managed Kubernetes for container orchestration.                                | ~$60+ (2 t3.medium nodes + EKS fee) |
| **App Runner**                       | Fully managed service for containerized web apps and APIs.                     | ~$7+ (0.5 vCPU, 1GB, 24/7)          |
| **Lightsail**                        | Simplified VPS with predictable pricing.                                       | $3.50+ (base plan)                  |

> **Note:** Prices are approximate and may vary by region and usage. Always check the [AWS Pricing Calculator](https://calculator.aws.amazon.com/) for up-to-date costs.

## Use Cases

- **EC2 (Elastic Compute Cloud):**

  - When you need full control over the environment or have specific OS/kernel requirements.
  - Running legacy applications or custom software stacks.
  - Hosting web servers, databases, or any backend service.

- **Elastic Beanstalk:**

  - Rapid deployment and management of web applications without managing infrastructure.
  - Auto-scaling and load balancing for web apps.
  - Developers who want to focus on code, not infrastructure.

- **Lambda (Serverless):**

  - Event-driven workloads, such as APIs, scheduled jobs, or file processing.
  - Microservices and backend logic that only runs on demand.
  - Reducing operational overhead for small, bursty workloads.

- **ECS (Elastic Container Service):**

  - Running containerized applications at scale.
  - Microservices architectures using Docker.
  - Applications requiring integration with other AWS services.

- **EKS (Elastic Kubernetes Service):**

  - Large-scale container orchestration using Kubernetes.
  - Portability for workloads between cloud and on-premises.
  - Teams already using Kubernetes.

- **App Runner:**

  - Quick deployment of containerized web apps and APIs from source or image.
  - Developers who want managed scaling and HTTPS out of the box.
  - Small to medium web services and APIs.

- **Lightsail:**
  - Simple, low-cost projects, prototypes, or learning environments.
  - Small business websites, blogs, or web apps.
  - Users who want predictable pricing and simplified management.

## 🧱 Basic Architecture Diagrams

### EC2

```
[User]--->[EC2 Instance]
```

### Elastic Beanstalk

```
[User]--->[Elastic Load Balancer]--->[Elastic Beanstalk Environment]--->[EC2 Instance(s)]
```

### Lambda (Serverless)

```
[User]--->[API Gateway]--->[Lambda Function]
```

### ECS (Fargate Example)

```
[User]--->[Application Load Balancer] ---> [ECS Service (Flask App on Fargate)] ---> [Docker Container]
```

### EKS

```
[User]--->[Load Balancer]--->[EKS Cluster]--->[Kubernetes Pods]
```

### App Runner

```
[User]--->[App Runner Service]--->[Containerized App]
```

### Lightsail

```
[User]--->[Lightsail Instance]
```
