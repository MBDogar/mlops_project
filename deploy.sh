#!/bin/bash
set -e

echo "[1/6] Changing to project directory..."
cd /home/murtazabilalqasim/mlops_project

echo "[2/6] Pulling latest code from main branch..."
git pull origin main

echo "[3/6] Building Docker image..."
docker build -t height-app:latest .

echo "[4/6] Loading Docker image into Minikube..."
minikube image load height-app:latest

echo "[5/6] Applying Kubernetes manifests..."
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "[6/6] Deployment complete!"