#!/bin/bash

TENANT_ID="hono-soc-tenant"
DEVICE_ID="sovd-server-001"
DEVICE_PASSWORD="sovd-secret-123"

echo "Creating tenant and registering test device..."

# Create tenant
echo "Creating tenant: $TENANT_ID"
curl -X POST http://localhost:28080/v1/tenants/$TENANT_ID \
  -H "Content-Type: application/json" \
  -d '{
    "enabled": true,
    "defaults": {
      "ttl": 3600
    },
    "adapters": [
      {
        "type": "http",
        "enabled": true,
        "device-authentication-required": true
      },
      {
        "type": "mqtt", 
        "enabled": true,
        "device-authentication-required": true
      }
    ]
  }'

echo ""

# Register device
echo "Registering device: $DEVICE_ID"
curl -X POST http://localhost:28080/v1/devices/$TENANT_ID \
  -H "Content-Type: application/json" \
  -d "{\"device-id\": \"$DEVICE_ID\", \"enabled\": true}"

echo ""

# Set device credentials
echo "Setting device credentials..."
curl -X PUT http://localhost:28080/v1/credentials/$TENANT_ID/$DEVICE_ID \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"hashed-password\",
    \"auth-id\": \"$DEVICE_ID\",
    \"secrets\": [{
      \"pwd-plain\": \"$DEVICE_PASSWORD\"
    }]
  }"

echo ""
echo "Device registration completed!"
echo "Tenant: $TENANT_ID"
echo "Device: $DEVICE_ID"
echo "Password: $DEVICE_PASSWORD"
