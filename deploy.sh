#!/bin/bash
set -e

cd ~/mlops_project

# Use unique image tag
TAG="height-app:build-$(date +%s)"
echo "🏗️ Building image: $TAG"
docker build -t height-app:latest .

# Load image into Minikube
echo "📤 Loading image into Minikube..."
minikube image load height-app:latest

# Optional: delete old deployment (ignore error if not found)
/usr/local/bin/minikube kubectl delete deployment height-app || true

# Apply manifests
/usr/local/bin/minikube kubectl apply -f k8s/deployment.yaml
/usr/local/bin/minikube kubectl apply -f k8s/service.yaml

echo "✅ Done! Image used: height-app:latest"
