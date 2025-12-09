FROM nginx:perl

# BUILD TIME ARGUMENTS
ARG CONF_TEMPLATE_PATH_REVERSE_PROXY
ARG CONF_TEMPLATE_PATH_MAIN_CONFIG
ARG PROXY_PARAMS_PATH

# ENVIRONMENT VARIABLES
# Remeber; these variables are only default values. If you run this via docker-compose (which is intended),
# they will be replaced with the values from the .env file.
# Keep names of the variables in sync with the .env file.
ENV NGINX_HOST_DOMAIN=localhost
ENV TZ=Europe/Warsaw
ENV MAX_BODY_SIZE_BACKEND=512M
ENV MAX_BODY_SIZE_FRONTEND=10M
ENV MAX_FAILS=4
ENV FAIL_TIMEOUT=35s
ENV KEEP_ALIVE=32
ENV DSPACE_DSPACE_TOMCAT_HOST=dspace-backend-tomcat
ENV DSPACE_DSPACE_TOMCAT_PORT=8080
ENV DSPACE_UI_HOST=dspace-frontend
ENV DSPACE_UI_PORT=4000
ENV PROXY_READ_TIMEOUT=90s
ENV PROXY_CONNECT_TIMEOUT=90s
ENV PROXY_SEND_TIMEOUT=90s
ENV WORKER_CONNECTIONS=4096
ENV WORKER_RLIMIT_NOFILE=8192

# Main config file template.
COPY ${CONF_TEMPLATE_PATH_MAIN_CONFIG} /etc/nginx/nginx.conf.template

# Reverse proxy config template.
COPY ${CONF_TEMPLATE_PATH_REVERSE_PROXY} /etc/nginx/templates/default.conf.template

# Common params for the backend and frontend.
COPY ${PROXY_PARAMS_PATH} /etc/nginx/proxy_params.template

# Custom entrypoint script
COPY ./docker-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh

# PORTS
# Expose HTTP and HTTPS protocols ports
EXPOSE 80
EXPOSE 443

# ENTRYPOINT
ENTRYPOINT ["/custom-entrypoint.sh"]

# CMD
CMD ["nginx", "-g", "daemon off;"]