FROM tutum/nginx
RUN rm /etc/nginx/sites-enabled/default
ADD sites-enabled/ /etc/nginx/sites-enabled

#COPY kibana.htpasswd /etc/nginx/conf.d/kibana.htpasswd

RUN mkdir /logs
RUN ln -sf /dev/stdout /logs/nginx_access.log
RUN ln -sf /dev/stderr /logs/nginx_error.log


VOLUME /var/log
