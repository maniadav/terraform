# **Terraform ECS Fargate Deployment Guide**

## **Overview**

This guide explains how to deploy a **Dockerized Node.js app** on **AWS ECS Fargate** using **Terraform**, including:
✅ **ECR** (Elastic Container Registry) for Docker images
✅ **ECS Fargate** (serverless containers)
✅ **Application Load Balancer (ALB)** for public access
✅ **Auto Scaling** for handling traffic spikes

---

## **Prerequisites**

- **AWS Account** with IAM permissions
- **Terraform** installed (`v1.0+`)
- **AWS CLI** configured (`aws configure`)
- **Docker** installed (for building/pushing images)

---

## **Terraform Files Structure**

| File               | Purpose                                                   |
| ------------------ | --------------------------------------------------------- |
| `main.tf`        | Defines AWS provider and main resources (ECS, ALB, ECR)   |
| `variables.tf`   | Contains configurable variables (region, app name, ports) |
| `outputs.tf`     | Outputs useful info (ALB DNS, ECR repo URL)               |
| `ecs.tf`         | ECS cluster, task definition, and service                 |
| `alb.tf`         | Load balancer, target group, and security groups          |
| `autoscaling.tf` | Auto-scaling policies for ECS                             |

---

## **Step 1: Set Up Terraform Configuration**

### **1. `variables.tf` (Configurable Settings)**

```hcl
variable "aws_region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "app_name" {
  description = "Application name"
  default     = "nodedocker"
}

variable "app_port" {
  description = "Port exposed by the Docker image"
  default     = 8000
}

variable "health_check_path" {
  description = "Health check endpoint"
  default     = "/health"
}
```

### **2. `main.tf` (AWS Provider & ECR Setup)**

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create ECR repository for Docker image
resource "aws_ecr_repository" "app" {
  name                 = "${var.app_name}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
```

---

## **Step 2: Configure Load Balancer & Networking (`alb.tf`)**

```hcl
# Security group for ALB (allows HTTP traffic)
resource "aws_security_group" "alb_sg" {
  name        = "${var.app_name}-alb-sg"
  description = "Allow HTTP inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALB and Target Group
resource "aws_lb" "app" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-123456", "subnet-789012"] # Replace with your public subnets
}

resource "aws_lb_target_group" "app" {
  name        = "${var.app_name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-123456" # Replace with your VPC

  health_check {
    path                = var.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ALB Listener (HTTP → Target Group)
resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
```

---

## **Step 3: Set Up ECS Fargate (`ecs.tf`)**

```hcl
# ECS Cluster (Fargate)
resource "aws_ecs_cluster" "app" {
  name = "${var.app_name}-cluster"
}

# Task Definition (Fargate-compatible)
resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024  # 1 vCPU
  memory                   = 3072  # 3GB

  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  container_definitions = jsonencode([{
    name  = "${var.app_name}-container"
    image = "${aws_ecr_repository.app.repository_url}:latest"
    portMappings = [{
      containerPort = var.app_port
      hostPort      = var.app_port
    }]
  }])
}

# ECS Service (with ALB integration)
resource "aws_ecs_service" "app" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-123456", "subnet-789012"] # Same as ALB subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "${var.app_name}-container"
    container_port   = var.app_port
  }
}
```

---

## **Step 4: Add Auto Scaling (`autoscaling.tf`)**

```hcl
# Auto-scaling for ECS
resource "aws_appautoscaling_target" "app" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.app.name}/${aws_ecs_service.app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up" {
  name               = "${var.app_name}-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.app.resource_id
  scalable_dimension = aws_appautoscaling_target.app.scalable_dimension
  service_namespace  = aws_appautoscaling_target.app.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
```

---

## **Step 5: Deploy with Terraform**

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply -auto-approve

# Get ALB DNS (after deployment)
terraform output alb_dns
```

---

## **Step 6: Push Docker Image to ECR**

```bash
# Authenticate Docker with ECR
aws ecr get-login-password --region $(terraform output -raw aws_region) | docker login --username AWS --password-stdin $(terraform output -raw ecr_repo_url)

# Build, tag, and push
docker build -t $(terraform output -raw ecr_repo_url) .
docker push $(terraform output -raw ecr_repo_url):latest
```

---

## **Troubleshooting**

🔹 **ALB DNS not working?**
✔ Check **Security Groups** (allow HTTP on port 80).
✔ Verify **ECS tasks** are running (`aws ecs describe-tasks`).
✔ Check **Target Group health** in AWS Console.

🔹 **Task failing to start?**
✔ Check **CloudWatch Logs** for errors.
✔ Ensure the **Docker image URI** is correct in `ecs.tf`.

---

## **Destroy Resources (Cleanup)**

```bash
terraform destroy -auto-approve
```

---

## **Conclusion**

This Terraform setup automates:
🚀 **ECR + ECS Fargate deployment**
🚀 **Load-balanced API with auto-scaling**
🚀 **Secure & scalable infrastructure**

**Next Steps**:
🔹 Add **HTTPS** (ACM certificate + ALB listener).
🔹 Set up **CI/CD** (GitHub Actions/CodePipeline).

🎉 **Happy Infrastructure-as-Coding!** 🎉
