FROM tutum/nginx
RUN rm /etc/nginx/sites-enabled/default
ADD sites-enabled/ /etc/nginx/sites-enabled

#COPY kibana.htpasswd /etc/nginx/conf.d/kibana.htpasswd

VOLUME /var/log
