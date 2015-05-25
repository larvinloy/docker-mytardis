#FROM        ubuntu:14.04
FROM        mytardisbase:latest
MAINTAINER  Ian Thomas <iantedwardthomas@gmail.com>

USER root

RUN mkdir -p /var/run/gunicorn/mytardis
RUN chown mytardis.nginx /var/run/gunicorn/mytardis

WORKDIR /opt/mytardis/webapp

# setup gunicorn
COPY gunicorn_conf.py /opt/mytardis/webapp/gunicorn_conf.py

EXPOSE 8000

VOLUME /opt/mytardis/webapp/static

RUN mkdir /etc/service/01gunicorn
ADD gunicorn_run.sh /etc/service/01gunicorn/run
RUN chmod +x /etc/service/01gunicorn/run
CMD ["/sbin/my_init"]


