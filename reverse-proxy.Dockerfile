FROM nginx:perl

# BUILD TIME ARGUMENTS
ARG CONF_TEMPLATE_PATH_REVERSE_PROXY

# ENVIRONMENT VARIABLES
# Remeber to add here the variables from the .env file if you want to use them in the nginx config template files.
ENV NGINX_HOST_DOMAIN=localhost
ENV TZ=Europe/Warsaw
ENV MAX_BODY_SIZE=512M   
ENV MAX_FAILS=4
ENV FAIL_TIMEOUT=35s
ENV KEEP_ALIVE=32

COPY ${CONF_TEMPLATE_PATH_REVERSE_PROXY} /etc/nginx/templates/default.conf.template

# PORTS
# Expose HTTP and HTTPS protocols ports
EXPOSE 80
EXPOSE 443

# COMMANDS
# To prevent Docker before killing the container
# (precisely, to keep the demon of the nginx running inside the container)
# run nging demon in the foreground
CMD ["nginx", "-g", "daemon off;"]