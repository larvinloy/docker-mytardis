FROM nginx:latest

COPY sites-enabled/mytardis /etc/nginx/conf.d/mytardis.conf

RUN mkdir /logs
RUN ln -sf /dev/stdout /logs/nginx_access.log
RUN ln -sf /dev/stderr /logs/nginx_error.log


VOLUME /var/log
