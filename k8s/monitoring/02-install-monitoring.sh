#!/bin/bash

# Monitoring stack installation script
# Deploys Prometheus and Grafana using Helm for comprehensive cluster observability

set -e

echo "Installing monitoring stack..."

# Add Prometheus community Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create monitoring namespace
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

# Install kube-prometheus-stack
helm upgrade --install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values 01-prometheus-values.yaml \
  --wait

echo "Monitoring stack installed successfully!"
echo ""
echo "Access Grafana:"
echo "  kubectl port-forward -n monitoring svc/kube-prometheus-stack-grafana 3000:80"
echo "  Username: admin"
echo "  Password: admin"
echo ""
echo "Access Prometheus:"
echo "  kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090"