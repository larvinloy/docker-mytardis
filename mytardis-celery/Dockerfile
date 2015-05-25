FROM        mytardisbase:latest
MAINTAINER  Ian Thomas <iantedwardthomas@gmail.com>

USER root

WORKDIR /opt/mytardis/webapp

EXPOSE 80

ADD celery_conf.py /opt/mytardis/webapp/tardis/celery_conf.py

VOLUME /logs

RUN mkdir /etc/service/01celery
ADD celery_run.sh /etc/service/01celery/run
RUN chmod +x /etc/service/01celery/run
CMD ["/sbin/my_init"]



