echo "🌀 Switching to Minikube Docker environment..."
eval $(minikube docker-env)

echo "🧠 Verifying Docker is using Minikube..."
docker info | grep -i minikube || { echo "❌ Not using Minikube's Docker daemon."; exit 1; }

echo "📂 Changing to project directory..."
cd ~/mlops_project  # Adjust this path

echo "🔍 Checking for Dockerfile..."
test -f ~/mlops_project/Dockerfile || { echo "❌ Dockerfile not found in $(pwd)"; exit 1; }

echo "🏗️ Running training script..."
python3 train.py

echo "🧪 Checking if model.joblib exists..."
test -f model.joblib || { echo "❌ model.joblib not found. train.py likely failed."; exit 1; }

echo "🔥 Removing previous image (if exists)..."
docker rmi height-app:latest || echo "No previous image to remove."

echo "📦 Building Docker image..."
docker build -t height-app:latest .

echo "✅ Checking image creation..."
docker images | grep height-app || { echo "❌ Image was not created."; exit 1; }

echo "📤 Loading image into Minikube..."
minikube image load height-app:latest

echo "🚀 Redeploying to Kubernetes..."
kubectl delete deployment height-app --ignore-not-found
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo "✅ Deployment complete!"
kubectl delete deployment height-app --ignore-not-found

echo ">>> Applying Kubernetes manifests"
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml

echo ">>> Restarting deployment"
kubectl rollout restart deployment height-app

echo ">>> Done"
