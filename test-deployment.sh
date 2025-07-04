#!/bin/bash

echo "Testing HONO-SOC Module 3 deployment..."

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 60

# Test 1: Device Registry API
echo "Testing Device Registry API..."
curl -f http://localhost:28080/v1/tenants || echo "Device Registry test failed"

# Test 2: HTTP Adapter
echo "Testing HTTP Adapter..."
curl -f http://localhost:18080/ || echo "HTTP Adapter test failed"

# Test 3: Auth Server (check if AMQP port is open)
echo "Testing Auth Server AMQP port..."
nc -z localhost 25672 && echo "Auth Server AMQP port is open" || echo "Auth Server AMQP port test failed"

# Test 4: Dispatch Router
echo "Testing Dispatch Router AMQP port..."
nc -z localhost 15672 && echo "Dispatch Router AMQP port is open" || echo "Dispatch Router AMQP port test failed"

# Test 5: MongoDB
echo "Testing MongoDB connection..."
nc -z localhost 27017 && echo "MongoDB port is open" || echo "MongoDB port test failed"

echo "Basic connectivity tests completed!"
