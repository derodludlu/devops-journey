$ErrorActionPreference = "Stop"
Write-Host "🚀 Starting local CI pipeline..." -ForegroundColor Cyan

Write-Host "🔨 Step 1: Building Docker image..."
docker build -t mydevops-app ./week2-app

Write-Host "🏃 Step 2: Starting container..."
docker run -d -p 5000:5000 --name ci-test mydevops-app

Write-Host "⏳ Step 3: Waiting for app to start..."
Start-Sleep -Seconds 5

Write-Host "🔍 Step 4: Running health check..."
$statusCode = (curl.exe -s -o nul -w "%{http_code}" http://localhost:5000/health)
if ($statusCode -ne "200") { 
    throw "❌ Health check failed with status $statusCode" 
}

Write-Host "🧹 Step 5: Cleaning up..."
docker stop ci-test -ErrorAction SilentlyContinue | Out-Null
docker rm ci-test -ErrorAction SilentlyContinue | Out-Null

Write-Host "✅ Local CI pipeline completed successfully!" -ForegroundColor Green