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

/usr/local/bin/minikube/kubectl delete deployment height-app

# Apply manifests (if not already present)
/usr/local/bin/minikube/kubectl apply -f k8s/deployment.yaml
/usr/local/bin/minikube/kubectl apply -f k8s/service.yaml

# Update deployment with new image
#echo "🛠️ Updating Kubernetes deployment with image $TAG"
#/usr/local/bin/minikube/kubectl set image deployment/height-app height-app=$TAG --record

#kubectl rollout restart deployment height-app

echo "✅ Done! New image: $TAG"
