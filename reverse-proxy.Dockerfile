FROM nginx:perl


# BUILD TIME ARGUMENTS
ARG CONF_TEMPLATE_PATH_REVERSE_PROXY

# ENVIRONMENT VARIABLES
ENV NGINX_HOST=${NGINX_HOST:-localhost}
ENV TZ=${TIMEZONE:-Europe/Warsaw}

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