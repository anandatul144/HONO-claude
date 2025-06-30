#!/bin/bash
# scripts/register-device.sh

TENANT_ID="hono-soc-tenant"
DEVICE_ID="sovd-server-001"
DEVICE_PASSWORD="sovd-secret"

echo "Registering device $DEVICE_ID in tenant $TENANT_ID..."

# Register device
curl -X POST http://localhost:28080/v1/devices/$TENANT_ID \
  -H "Content-Type: application/json" \
  -d "{\"device-id\": \"$DEVICE_ID\", \"enabled\": true}"

# Set device credentials
curl -X PUT http://localhost:28080/v1/credentials/$TENANT_ID/$DEVICE_ID \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"hashed-password\",
    \"auth-id\": \"$DEVICE_ID\",
    \"secrets\": [{
      \"pwd-plain\": \"$DEVICE_PASSWORD\"
    }]
  }"

echo "Device registered successfully!"
