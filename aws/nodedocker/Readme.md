# **ECS Fargate Deployment Guide**

This guide explains how to deploy a Dockerized Node.js application to **AWS Elastic Container Service (ECS) with Fargate**, using **Amazon ECR (Elastic Container Registry)** for storing Docker images and an **Application Load Balancer (ALB)** to expose the API.

### **Why Use This Setup?**

- **ECR**: Securely store and manage Docker images.
- **ECS Fargate**: Serverless container orchestration (no EC2 management).
- **Load Balancer (ALB)**: Distributes traffic across containers and provides a single DNS endpoint.
- **Auto Scaling**: Automatically adjusts the number of running containers based on CPU/memory usage.

---

## **Prerequisites**

✅ **AWS Account** with IAM permissions for ECR, ECS, and ALB.
✅ **AWS CLI** installed and configured (`aws configure`).
✅ **Docker** installed locally.
✅ **Node.js app** with a `Dockerfile`.

---

## **Step 1: Push Docker Image to ECR**

### **1. Create an ECR Repository**

- **Name**: `nodedocker-ecr`
- **Tag**: Mutable (allows updates)
- **Visibility**: Private
- **Encryption**: AES-256

### **2. Build, Tag, and Push the Image**

```bash
# Authenticate Docker with ECR  
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 993484236288.dkr.ecr.ap-south-1.amazonaws.com  

# Build Docker image  
docker build -t nodedocker-ecr .  

# Tag the image  
docker tag nodedocker-ecr:latest 993484236288.dkr.ecr.ap-south-1.amazonaws.com/nodedocker-ecr:latest  

# Push to ECR  
docker push 993484236288.dkr.ecr.ap-south-1.amazonaws.com/nodedocker-ecr:latest  
```

**Note**: Keep the ECR image URI for later (`993484236288.dkr.ecr.ap-south-1.amazonaws.com/nodedocker-ecr:latest`).

---

## **Step 2: Set Up ECS Cluster & Task**

### **1. Create an ECS Cluster (Fargate - Serverless)**

- **Cluster Name**: `nodedocker-cluster`
- **Type**: Fargate (no expensive EC2 management)

### **2. Define a Task Definition**

- **Task Name**: `nodedocker-task`
- **Launch Type**: Fargate
- **OS**: Linux/ARM64
- **CPU & Memory**: 1 vCPU & 3GB
- **Container Definition**:
  - **Name**: `nodedocker-container`
  - **Image**: Use the ECR URI from Step 1
  - **Port**: `8000` (must match your app’s port)
  - **Health Check**:

    ```bash
    CMD-SHELL, curl -f http://localhost:8000/health || exit 1
    ```

    (Adjust `/health` to your app’s health endpoint.)

---

## **Step 3: Deploy the Service with a Load Balancer**

### **1. Create an ECS Service**

- **Service Name**: `nodedocker-task-service`
- **Task Definition**: Select `nodedocker-task`
- **Desired Tasks**: `2` (minimum running instances)
- **Capacity Provider**: fargate
- **Service Type**: replica
- security
- **Load Balancer**:
  - **Type**: Application Load Balancer (ALB)
  - **Name**: `nodedocker-loadbalancer`
  - **Target Group**: `nodedocker-targetgroup` (port `8000`)
  - **Health Check Path**: `/health`

### **2. Configure Auto Scaling**

- **Min Tasks**: `2`
- **Max Tasks**: `10`
- **Scaling Policy**:
  - **Metric**: CPU Utilization
  - **Target**: `70%`

---

## **Step 4: Access the API via Load Balancer DNS**

1. Go to **EC2 > Load Balancers** and copy the ALB’s DNS (e.g., `nodedocker-loadbalancer-123456789.ap-south-1.elb.amazonaws.com`).
2. Test the API:

   ```bash
   curl http://nodedocker-loadbalancer-123456789.ap-south-1.elb.amazonaws.com/api
   ```

   (Replace `/api` with your endpoint.)

---

## **Step 5: Updating the Service (New Deployments)**

When you push a new Docker image to ECR:

1. Go to **ECS > Services > nodedocker-task-service**.
2. Click **Update Service**.
3. Check **Force new deployment** to ensure the latest image is used.
