FROM nginx:perl

ENV NGINX_HOST=${NGINX_HOST:-localhost}
ENV TZ=${TIMEZONE:-Europe/Warsaw}

COPY ${nginx-config-path:-/conf/nginx/conf.d} /etc/nginx/conf.d/default.conf

EXPOSE ${NGINX_PORT:-80} 

# cmd
# To prevent Docker before killing the container
# (precisely, to keep the demon of the nginx running inside the container)
# run nging demon in the foreground
CMD ["nginx", "-g", "daemon off;"]