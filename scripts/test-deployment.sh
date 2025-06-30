#!/bin/bash
# scripts/test-deployment.sh

echo "Testing HONO-SOC Module 3 deployment..."

# Test 1: Device Registry API
echo "Testing Device Registry API..."
curl -f http://localhost:28080/v1/tenants/hono-soc-tenant

# Test 2: HTTP Adapter
echo "Testing HTTP Adapter..."
curl -f http://localhost:18080/health

# Test 3: MQTT Adapter connectivity
echo "Testing MQTT Adapter..."
mosquitto_pub -h localhost -p 1883 -t "telemetry/hono-soc-tenant/sovd-server-001" \
  -u "sovd-server-001@hono-soc-tenant" -P "sovd-secret" \
  -m '{"temp": 23.5, "humidity": 60}' || echo "MQTT test failed"

echo "All tests completed!"
