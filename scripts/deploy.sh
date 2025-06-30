#!/bin/bash
# scripts/deploy.sh

echo "Starting HONO-SOC Module 3 deployment..."

# Generate certificates if they don't exist
if [ ! -f "./certs/ca-cert.pem" ]; then
    echo "Generating certificates..."
    ./scripts/generate-certs.sh
fi

# Start the stack
echo "Starting Hono services..."
podman-compose up -d

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 30

# Health check
echo "Performing health checks..."
curl -f http://localhost:28080/health || echo "Device Registry health check failed"
curl -f http://localhost:18080/health || echo "HTTP Adapter health check failed"

echo "Deployment complete!"
echo "Device Registry: http://localhost:28080"
echo "HTTP Adapter: http://localhost:18080"
echo "MQTT Adapter: mqtt://localhost:1883"
```

### Step 5: Device Registration Script
