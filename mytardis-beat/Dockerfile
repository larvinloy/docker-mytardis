FROM        mytardisbase:latest
MAINTAINER  Ian Thomas <ianedwardthomas@gmail.com>

USER root

WORKDIR /opt/mytardis/webapp

RUN mkdir -p /logs/celery & chown mytardis.nginx /logs/celery

EXPOSE 80

ADD celery_conf.py /opt/mytardis/webapp/tardis/celery_conf.py

VOLUME /logs

RUN mkdir /etc/service/01celerybeat
ADD celerybeat_run.sh /etc/service/01celerybeat/run
RUN chmod +x /etc/service/01celerybeat/run
CMD ["/sbin/my_init"]

