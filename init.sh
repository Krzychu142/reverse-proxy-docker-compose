#!/bin/bash

# Get variables from .env file if it exists
if [ -f .env ]; then
  set -a
  [ -s .env ] && . .env
  set +a
fi

NETWORK_NAME=${GLOBAL_NETWORK:-global-network}

# Check if the network already exists and create it if it doesn't
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    echo "EXCEPTION: The network '$NETWORK_NAME' already exists. Skipping creation."
else
    echo "CREATING DOCKER NETWORK '$NETWORK_NAME'"
    docker network create "$NETWORK_NAME"
    
    if [ $? -eq 0 ]; then
        echo "CREATED: $NETWORK_NAME"
    else
        echo "EXCEPTION: Failed to create the network '$NETWORK_NAME'."
        exit 1
    fi
fi