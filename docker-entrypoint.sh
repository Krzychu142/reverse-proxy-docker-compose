#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--> Starting Custom Nginx Entrypoint Script"

# 1. Template the Main Nginx Config
echo "--> Templating nginx.conf..."
# Replace ONLY ${WORKER_X} variables (ignore NGINX internal variables like $host)
envsubst '${WORKER_CONNECTIONS} ${WORKER_RLIMIT_NOFILE}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# 2. Template the Proxy Params
echo "--> Templating proxy_params..."
# Replace ONLY ${PROXY_X} variables (ignore NGINX internal variables like $host)
envsubst '${PROXY_READ_TIMEOUT} ${PROXY_CONNECT_TIMEOUT} ${PROXY_SEND_TIMEOUT}' < /etc/nginx/proxy_params.template > /etc/nginx/proxy_params

# 3. Hand over control to the official Nginx entrypoint
# The official image has its own entrypoint that handles /etc/nginx/templates/ logic.
# We call it explicitly to make sure standard behavior (like default.conf templating) still works.
echo "--> Handing over to official Nginx entrypoint..."
exec /docker-entrypoint.sh "$@"