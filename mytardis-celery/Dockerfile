FROM        phusion/baseimage:0.9.16


MAINTAINER  Ian Thomas <iantedwardthomas@gmail.com>

# Install prerequisites
RUN apt-get -y update && apt-get -y install python-pip git libxml2-dev libxslt1-dev python-dev zlib1g-dev python-wand python-virtualenv virtualenvwrapper python-psycopg2 python-yaml ipython python-anyjson python-bs4 python-billiard python-feedparser python-html5lib python-httplib2 python-pystache python-crypto python-flexmock python-dateutil supervisor gunicorn nginx pwgen

# Get mytardis source
RUN groupadd -r nginx && adduser --home /opt/mytardis --disabled-password --ingroup nginx --gecos '' mytardis
USER mytardis
ENV MYTARDIS_URL https://github.com/mytardis/mytardis.git
ENV MYTARDIS_BRANCH 3.7
#ENV MYTARDIS_BRANCH develop

RUN cd /opt/mytardis &&  git clone -b ${MYTARDIS_BRANCH} ${MYTARDIS_URL} webapp
USER root

# Make staging and store volumes
RUN mkdir -p /staging
RUN mkdir -p /store
RUN chown -R mytardis:nginx /store
RUN chown -R mytardis:nginx /staging


# install mytardis
WORKDIR /opt/mytardis/webapp
#ADD build.sh /root/build.sh
#RUN bash /root/build.sh

RUN /usr/bin/pip install -U pip
RUN pip install -r requirements.txt



# configure settings
RUN mkdir -p /mytardis_settings
ADD settings.py /opt/mytardis/webapp/tardis/settings.py
ADD mytardis_settings/ /mytardis_settings

RUN mkdir -p /logs
RUN chown -R mytardis:nginx /logs

VOLUME /store
VOLUME /staging
VOLUME /logs
VOLUME /tmp
VOLUME /mytardis_settings
VOLUME /var/log


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV INDEX=1
ENV LOGFILE=/logs/celery

USER root

WORKDIR /opt/mytardis/webapp

EXPOSE 80

ADD celery_conf.py /opt/mytardis/webapp/tardis/celery_conf.py


RUN mkdir -p /logs
RUN chown -R mytardis:nginx /logs

RUN mkdir /etc/service/01celery
ADD celery_run.sh /etc/service/01celery/run
RUN chmod +x /etc/service/01celery/run
CMD ["/sbin/my_init"]



