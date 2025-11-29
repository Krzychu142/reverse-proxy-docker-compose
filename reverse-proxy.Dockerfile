FROM nginx:perl

# BUILD TIME ARGUMENTS
ARG CONF_TEMPLATE_PATH_REVERSE_PROXY
ARG CONF_TEMPLATE_PATH_MAIN_CONFIG

# ENVIRONMENT VARIABLES
# Remeber; these variables are only default values. If you run this via docker-compose (which is intended),
# they will be replaced with the values from the .env file.
# Keep names of the variables in sync with the .env file.
ENV NGINX_HOST_DOMAIN=localhost
ENV TZ=Europe/Warsaw
ENV MAX_BODY_SIZE=512M   
ENV MAX_FAILS=4
ENV FAIL_TIMEOUT=35s
ENV KEEP_ALIVE=32
ENV DSPACE_DSPACE_TOMCAT_HOST=dspace-backend-tomcat
ENV DSPACE_DSPACE_TOMCAT_PORT=8080
ENV WORKER_CONNECTIONS=4096
ENV WORKER_RLIMIT_NOFILE=8192

# Main config file template.
COPY ${CONF_TEMPLATE_PATH_MAIN_CONFIG} /etc/nginx/nginx.conf.template

# Reverse proxy config template.
COPY ${CONF_TEMPLATE_PATH_REVERSE_PROXY} /etc/nginx/templates/default.conf.template

# PORTS
# Expose HTTP and HTTPS protocols ports
EXPOSE 80
EXPOSE 443

# COMMAND
# To use shell
# /bin/sh
# To execute the command
# -c

# Logic:
# Take the nginx.template.conf as a source: "< /etc/nginx/nginx.conf.template"
# Replace ONLY ${WORKER_X} variables (ignore NGINX internal variables like $host)
# Save result to /etc/nginx/nginx.conf (overwriting default config)
# if success (&&), start nginx with daemon off to prevent the container from exiting.
CMD ["/bin/sh", "-c", "envsubst '${WORKER_CONNECTIONS} ${WORKER_RLIMIT_NOFILE}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"]