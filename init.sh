#!/bin/bash

# Get variables from .env file if it exists
if [ -f .env ]; then
  set -a
  [ -s .env ] && . .env
  set +a
fi

# Value of the .env variable GLOBAL_NETWORK or default value.
NETWORK_NAME=${GLOBAL_NETWORK:-global-network}

# Check if the network with the same name already exists and create it if it doesn't
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
    # The network already exists.
    echo "EXCEPTION: The network '$NETWORK_NAME' already exists. Skipping creation."
else
    # The network doesn't exist. Create it.
    echo "CREATING DOCKER NETWORK '$NETWORK_NAME'"
    docker network create "$NETWORK_NAME"
    
    if [ $? -eq 0 ]; then
        # The network creation was successful.
        echo "CREATED: $NETWORK_NAME"
    else
        # The network creation failed.
        echo "EXCEPTION: Failed to create the network '$NETWORK_NAME'."
        exit 1
    fi
fi