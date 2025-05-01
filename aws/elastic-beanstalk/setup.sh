#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Checking AWS credentials..."
if ! aws sts get-caller-identity &>/dev/null; then
    echo -e "${RED}AWS credentials not configured. Please run 'aws configure' first.${NC}"
    exit 1
fi

BUCKET_NAME="terraform-state-backend-elastic-beanstalk"
STATE_KEY="elastic-beanstalk/terraform.tfstate"

echo "Checking for existing state..."
if aws s3api head-bucket --bucket $BUCKET_NAME 2>/dev/null; then
    if aws s3 ls s3://$BUCKET_NAME/$STATE_KEY &>/dev/null; then
        echo -e "${GREEN}Existing state found in S3. This is Scenario 1 (existing project).${NC}"
        echo "Proceeding with terraform init to fetch existing state..."
        terraform init
    else
        echo -e "${YELLOW}S3 bucket exists but no state file found.${NC}"
        echo "This might be a partially initialized project."
        read -p "Do you want to treat this as a new project? (y/n) " answer
        if [[ $answer =~ ^[Yy]$ ]]; then
            echo "Proceeding with new project initialization..."
            (cd backend-setup && terraform init && terraform apply -auto-approve)
            terraform init
        fi
    fi
else
    echo -e "${YELLOW}No existing state found. This is Scenario 2 (new project).${NC}"
    echo "Setting up backend infrastructure..."
    (cd backend-setup && terraform init && terraform apply -auto-approve)
    echo "Initializing main configuration..."
    terraform init
fi

echo -e "${GREEN}Setup complete!${NC}"
echo "You can now use terraform plan, apply, or destroy as needed."