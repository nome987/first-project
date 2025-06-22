#!/bin/bash

# AI Resume Builder Deployment Script

set -e

echo "🚀 Starting AI Resume Builder deployment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p uploads logs ssl static

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating environment file..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your configuration before running the application."
fi

# Build and start services
echo "🔨 Building and starting services..."
docker-compose down --remove-orphans
docker-compose build --no-cache
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check if services are running
echo "🔍 Checking service health..."
if curl -f http://localhost:5000/health > /dev/null 2>&1; then
    echo "✅ AI Resume Builder is running successfully!"
    echo "🌐 Application URL: http://localhost"
    echo "📊 Health Check: http://localhost:5000/health"
    echo "🔧 API Status: http://localhost:5000/api/status"
else
    echo "❌ Service health check failed. Checking logs..."
    docker-compose logs ai-resume-builder
    exit 1
fi

# Show running containers
echo "📋 Running containers:"
docker-compose ps

echo "🎉 Deployment completed successfully!"
echo ""
echo "📖 Next steps:"
echo "1. Edit .env file with your configuration"
echo "2. Access the application at http://localhost"
echo "3. Check logs with: docker-compose logs -f"
echo "4. Stop services with: docker-compose down"