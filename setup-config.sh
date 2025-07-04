#!/bin/bash

echo "Setting up Hono 2.6.0 configuration..."

# Create directory structure
mkdir -p config/dispatch
mkdir -p config/auth-server

# Create qdrouterd.conf
cat > config/dispatch/qdrouterd.conf << 'EOF'
router {
    mode: standalone
    id: Hono.Router
    workerThreads: 4
}

listener {
    host: 0.0.0.0
    port: 5672
    authenticatePeer: no
    saslMechanisms: ANONYMOUS
}

address {
    prefix: telemetry/
    distribution: balanced
}

address {
    prefix: event/
    distribution: balanced
}

address {
    prefix: command/
    distribution: balanced
}

address {
    prefix: command_response/
    distribution: balanced
}
EOF

# Create permissions.json
cat > config/auth-server/permissions.json << 'EOF'
{
  "roles": {
    "protocol-adapter": [
      "registration/*:*",
      "credentials/*:*",
      "tenant/*:*",
      "command_response/*:*"
    ],
    "consumer": [
      "telemetry/*:*",
      "event/*:*",
      "command_response/*:*"
    ],
    "application": [
      "command/*:*"
    ]
  },
  "users": {
    "http-adapter@HONO": {
      "mechanism": "PLAIN",
      "password": "http-secret",
      "authorities": ["protocol-adapter"]
    },
    "mqtt-adapter@HONO": {
      "mechanism": "PLAIN", 
      "password": "mqtt-secret",
      "authorities": ["protocol-adapter"]
    },
    "registry-adapter@HONO": {
      "mechanism": "PLAIN",
      "password": "registry-secret", 
      "authorities": ["protocol-adapter"]
    },
    "command-router@HONO": {
      "mechanism": "PLAIN",
      "password": "command-secret", 
      "authorities": ["protocol-adapter"]
    },
    "consumer@HONO": {
      "mechanism": "PLAIN",
      "password": "consumer-secret", 
      "authorities": ["consumer"]
    },
    "application@HONO": {
      "mechanism": "PLAIN",
      "password": "app-secret", 
      "authorities": ["application"]
    }
  }
}
EOF

echo "Configuration files created successfully!"
echo "Run: chmod +x setup-config.sh && ./setup-config.sh"

