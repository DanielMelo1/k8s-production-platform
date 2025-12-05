#!/bin/bash

# EKS Cluster Deployment Script
# This script automates the deployment of the Kubernetes cluster
# Author: Daniel Augusto Melo

set -e

echo "====================================="
echo "EKS Cluster Deployment"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Change to terraform directory
cd terraform/environments/dev

# Check if AWS credentials are configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}Error: AWS credentials not configured${NC}"
    echo "Run: aws configure"
    exit 1
fi

echo -e "${GREEN}AWS credentials verified${NC}"

# Initialize Terraform
echo -e "${YELLOW}Initializing Terraform...${NC}"
terraform init

# Validate configuration
echo -e "${YELLOW}Validating Terraform configuration...${NC}"
terraform validate

# Plan deployment
echo -e "${YELLOW}Planning infrastructure deployment...${NC}"
terraform plan -out=tfplan

# Ask for confirmation
echo -e "${YELLOW}Do you want to proceed with deployment? (yes/no)${NC}"
read -r confirmation

if [ "$confirmation" != "yes" ]; then
    echo -e "${RED}Deployment cancelled${NC}"
    exit 0
fi

# Apply configuration
echo -e "${GREEN}Deploying infrastructure...${NC}"
terraform apply tfplan

# Configure kubectl
echo -e "${YELLOW}Configuring kubectl...${NC}"
CLUSTER_NAME=$(terraform output -raw cluster_name)
REGION=$(terraform output -raw region)

aws eks update-kubeconfig --region "$REGION" --name "$CLUSTER_NAME"

echo -e "${GREEN}Kubectl configured successfully${NC}"

# Verify cluster access
echo -e "${YELLOW}Verifying cluster access...${NC}"
kubectl get nodes

echo -e "${GREEN}====================================="
echo "Deployment completed successfully!"
echo "=====================================${NC}"
echo ""
echo "Cluster name: $CLUSTER_NAME"
echo "Region: $REGION"
echo ""
echo "Next steps:"
echo "1. Deploy applications: kubectl apply -f k8s/app/"
echo "2. Deploy monitoring: kubectl apply -f k8s/monitoring/"
echo "3. Check pods: kubectl get pods --all-namespaces"