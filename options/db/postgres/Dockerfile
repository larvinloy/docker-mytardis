FROM        phusion/baseimage:0.9.16

MAINTAINER  Ian Thomas <ianedwardthomas@gmail.com> and Iman Yusuf <iimanyusuf@gmail.com>

# Install prerequisites
RUN apt-get -y update && apt-get -y install python-pip git libxml2-dev libxslt1-dev python-dev zlib1g-dev python-wand python-virtualenv virtualenvwrapper python-psycopg2 python-yaml ipython python-anyjson python-bs4 python-billiard python-feedparser python-html5lib python-httplib2 python-pystache python-crypto python-flexmock python-dateutil supervisor gunicorn nginx pwgen libldap2-dev libsasl2-dev libmysqlclient-dev libjpeg-dev  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Get mytardis source
RUN groupadd -r nginx && adduser --home /opt/mytardis --disabled-password --ingroup nginx --gecos '' mytardis
USER mytardis
ENV MYTARDIS_URL https://github.com/mytardis/mytardis.git
ENV MYTARDIS_BRANCH 3.7

RUN cd /opt/mytardis &&  git clone -b ${MYTARDIS_BRANCH} ${MYTARDIS_URL} webapp \
    && cd /opt/mytardis/webapp #
USER root

# Make staging and store volumes
RUN mkdir -p /staging
RUN mkdir -p /store
RUN chown -R mytardis:nginx /store
RUN chown -R mytardis:nginx /staging

# install mytardis
WORKDIR /opt/mytardis/webapp

RUN /usr/bin/pip install -U pip

#Remove following line when 3.7  branch is updated
ADD requirements.txt /opt/mytardis/webapp/requirements.txt

RUN pip install -r requirements.txt

RUN mkdir -p /logs
RUN chown -R mytardis:nginx /logs

ADD celery_conf.py /opt/mytardis/webapp/tardis/celery_conf.py

# configure settings
RUN mkdir -p /mytardis_settings
ADD settings.py /opt/mytardis/webapp/tardis/settings.py
ADD mytardis_settings/ /mytardis_settings

# Setup beat/celery logs
RUN mkdir -p /logs/beat && touch /logs/beat/beat.log && chown -R mytardis.nginx /logs/beat
RUN mkdir -p /logs/celery && touch /logs/celery/celery.log && chown -R mytardis.nginx /logs/celery

RUN touch /logs/tardis.log && chown -R mytardis.nginx /logs/tardis.log
RUN touch /logs/request.log && chown -R mytardis.nginx /logs/request.log

# setup beat/celery pids
RUN mkdir -p /var/run/celery && chown -R mytardis.nginx /var/run/celery
RUN mkdir -p /var/run/beat && chown -R mytardis.nginx /var/run/beat

ENV INDEX=1
ENV LOGFILE=/logs/celery

# Install MyData app
ENV MYDATA_URL https://github.com/wettenhj/mytardis-app-mydata
ENV MYDATA_COMMIT 2faeb6b2fc8787e547037904d89a860afce0d800
RUN cd tardis/apps && git clone ${MYDATA_URL} mydata
RUN cd tardis/apps/mydata &&  git reset --hard ${MYDATA_COMMIT} && pip install -r requirements.txt
#Create mydata account
RUN adduser --disabled-password --gecos "" mydata
RUN mkdir /home/mydata/.ssh
RUN touch /home/mydata/.ssh/authorized_keys
RUN chown -R mydata:mydata /home/mydata/.ssh/
RUN chmod 700 /home/mydata/.ssh/
RUN chmod 600 /home/mydata/.ssh/authorized_keys
RUN usermod -a -G www-data mydata
#Create storage for staging data transfer via SCP MyData
RUN mkdir -p /mydatastaging &&  chmod -R 775 /mydatastaging
RUN chown -R mytardis.nginx  /mydatastaging/ #nocache



# setup celery/beat/gunicorn
ENV CELERY_SOFT_TIME_LIMIT 155200
ENV CELERY_TIME_LIMIT 115400
ENV CELERY_LOG_LEVEL WARN
ENV GUNICORN_PORT 8000
ENV GUNICORN_LOG_LEVEL DEBUG
COPY run/sftp_run.sh /
RUN chmod u+x /sftp_run.sh
COPY run/gunicorn_run.sh /
RUN chmod u+x /gunicorn_run.sh
COPY run/celery_run.sh /
RUN chmod u+x /celery_run.sh
COPY run/celerybeat_run.sh /
RUN chmod u+x /celerybeat_run.sh
COPY run/waitforit.sh /
RUN chmod u+x /waitforit.sh
COPY celery_conf.py /opt/mytardis/webapp/celery_conf.py
COPY gunicorn_conf.py /opt/mytardis/webapp/gunicorn_conf.py
COPY fixtures/defaultgroup.json /opt/mytardis/webapp/tardis/tardis_portal/fixtures/defaultgroup.json

# start script
COPY start.sh /
RUN chmod u+x /start.sh


EXPOSE 80
EXPOSE 22

LABEL org.mytardis.db=postgres

#VOLUME /var/log
#VOLUME /tmp
VOLUME /store
VOLUME /staging
VOLUME /logs
VOLUME /mytardis_settings
#VOLUME /var/run/beat
#VOLUME /var/run/celery
VOLUME /opt/mytardis/webapp/static
VOLUME /home/mydata/.ssh
VOLUME /mydatastaging

# http://engineeringblog.yelp.com/2016/01/dumb-init-an-init-for-docker.html
ENTRYPOINT ["dumb-init", "/start.sh"]
CMD ["gunicorn"]
