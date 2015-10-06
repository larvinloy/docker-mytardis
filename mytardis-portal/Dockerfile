FROM        phusion/baseimage:0.9.16


MAINTAINER  Ian Thomas <iantedwardthomas@gmail.com>

# Install prerequisites
RUN apt-get -y update && apt-get -y install python-pip git libxml2-dev libxslt1-dev python-dev zlib1g-dev python-wand python-virtualenv virtualenvwrapper python-psycopg2 python-yaml ipython python-anyjson python-bs4 python-billiard python-feedparser python-html5lib python-httplib2 python-pystache python-crypto python-flexmock python-dateutil supervisor gunicorn nginx pwgen

# Fix sshd
RUN dpkg-reconfigure  openssh-server
RUN service ssh restart

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
#ADD mytardis-base/build.sh /root/build.sh
#RUN bash /root/build.sh


RUN /usr/bin/pip install -U pip
RUN pip install -r requirements.txt

# configure settings
RUN mkdir -p /mytardis_settings
ADD settings.py /opt/mytardis/webapp/tardis/settings.py
ADD mytardis_settings/ /mytardis_settings

RUN mkdir -p /logs
RUN chown -R mytardis:nginx /logs

# Install MyData app
RUN cd /opt/mytardis/webapp/tardis/apps && git clone https://github.com/wettenhj/mytardis-app-mydata mydata
RUN cd /opt/mytardis/webapp/tardis/apps/mydata && pip install -r requirements.txt
RUN echo "INSTALLED_APPS += ('tardis.apps.mydata',)" >> /opt/mytardis/webapp/tardis/settings_changeme.py



VOLUME /store
VOLUME /staging
VOLUME /logs
VOLUME /tmp
VOLUME /mytardis_settings
VOLUME /var/log


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER root

RUN mkdir -p /var/run/gunicorn/mytardis
RUN chown mytardis.nginx /var/run/gunicorn/mytardis

WORKDIR /opt/mytardis/webapp

# setup gunicorn
COPY gunicorn_conf.py /opt/mytardis/webapp/gunicorn_conf.py

EXPOSE 8000
EXPOSE 22

VOLUME /opt/mytardis/webapp/static

RUN mkdir -p /logs
RUN chown -R mytardis:nginx /logs
VOLUME /logs

RUN mkdir /etc/service/01gunicorn
ADD gunicorn_run.sh /etc/service/01gunicorn/run
RUN chmod +x /etc/service/01gunicorn/run
CMD ["/sbin/my_init"]


