#!/bin/bash
# scripts/generate-certs.sh

CERT_DIR="./certs"
mkdir -p $CERT_DIR

# Generate CA key and certificate
openssl genrsa -out $CERT_DIR/ca-key.pem 4096
openssl req -new -x509 -key $CERT_DIR/ca-key.pem -out $CERT_DIR/ca-cert.pem -days 365 \
    -subj "/C=US/ST=CA/L=San Francisco/O=HONO-SOC/CN=HONO-SOC-CA"

# Generate server key and certificate
openssl genrsa -out $CERT_DIR/key.pem 4096
openssl req -new -key $CERT_DIR/key.pem -out $CERT_DIR/cert.csr \
    -subj "/C=US/ST=CA/L=San Francisco/O=HONO-SOC/CN=hono-server"
openssl x509 -req -in $CERT_DIR/cert.csr -CA $CERT_DIR/ca-cert.pem -CAkey $CERT_DIR/ca-key.pem \
    -CAcreateserial -out $CERT_DIR/cert.pem -days 365

# Generate client certificates for testing
openssl genrsa -out $CERT_DIR/client-key.pem 4096
openssl req -new -key $CERT_DIR/client-key.pem -out $CERT_DIR/client.csr \
    -subj "/C=US/ST=CA/L=San Francisco/O=HONO-SOC/CN=test-client"
openssl x509 -req -in $CERT_DIR/client.csr -CA $CERT_DIR/ca-cert.pem -CAkey $CERT_DIR/ca-key.pem \
    -CAcreateserial -out $CERT_DIR/client-cert.pem -days 365

# Clean up CSR files
rm $CERT_DIR/*.csr

echo "Certificates generated in $CERT_DIR"
