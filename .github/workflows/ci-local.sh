#!/bin/bash
set -e  # Exit on any error

echo "🚀 Starting local CI pipeline..."

# Step 1: Checkout (we're already in the repo)
echo "✅ Step 1: Code checked out"

# Step 2: Build Docker image
echo "🔨 Step 2: Building Docker image..."
docker build -t mydevops-app ./week2-app

# Step 3: Run container
echo "🏃 Step 3: Starting container..."
docker run -d -p 5000:5000 --name ci-test mydevops-app

# Step 4: Wait for app startup
echo "⏳ Step 4: Waiting for app to start..."
sleep 5

# Step 5: Health check
echo "🔍 Step 5: Running health check..."
curl -f http://localhost:5000/health || { echo "❌ Health check failed"; exit 1; }

# Step 6: Cleanup
echo "🧹 Step 6: Cleaning up..."
docker stop ci-test >/dev/null 2>&1 || true
docker rm ci-test >/dev/null 2>&1 || true

echo "✅ Local CI pipeline completed successfully!"