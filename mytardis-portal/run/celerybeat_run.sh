#!/bin/bash

cd /opt/mytardis/webapp

if grep --quiet SECRET_KEY /mytardis_settings/docker_settings.py; then
    echo Secret key exists
else
    echo Generating new secret key
    python -c "import os; from random import choice; key_line = '%sSECRET_KEY=\"%s\"  # generated from build.sh\n' % ('from tardis.settings_changeme import * \n\n' if not os.path.isfile('tardis/settings.py') else '', ''.join([choice('abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)') for i in range(50)])); f=open('/mytardis_settings/docker_settings.py', 'a+'); f.write(key_line); f.close()"
fi


# need to sleep to make sure that db is ready before syndb runs
# there must be a better way of doing this...

function clean_up {
    echo cleaning up...
    rm -vf /var/run/beat/beat.pid
}

log_level=${BEAT_LOG_LEVEL:WARN}

sleep 30

clean_up

trap clean_up SIGTERM

echo beating...
# run Celery worker for our project myproject with Celery configuration stored in Celeryconf
su -m mytardis -c "python mytardis.py celerybeat --pidfile=/var/run/beat/beat.pid --logfile=/logs/beat/beat.log --loglevel=$log_level --schedule=/logs/beat/celerybeat-schedule"

clean_up

echo beat is done...
