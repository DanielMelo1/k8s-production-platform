#!/bin/bash

# EKS Cluster Destruction Script
# This script safely removes all infrastructure
# Author: Daniel Augusto Melo

set -e

echo "====================================="
echo "EKS Cluster Destruction"
echo "====================================="

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

cd terraform/environments/dev

# Warning
echo -e "${RED}WARNING: This will destroy all infrastructure!${NC}"
echo -e "${YELLOW}This action cannot be undone.${NC}"
echo ""
echo "Type 'destroy' to confirm:"
read -r confirmation

if [ "$confirmation" != "destroy" ]; then
    echo "Destruction cancelled"
    exit 0
fi

# Destroy infrastructure
echo -e "${YELLOW}Destroying infrastructure...${NC}"
terraform destroy -auto-approve

echo -e "${RED}====================================="
echo "All infrastructure has been destroyed"
echo "=====================================${NC}"