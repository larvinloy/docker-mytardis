#!/bin/sh

cd /opt/mytardis/webapp

if grep --quiet SECRET_KEY /mytardis_settings/docker_settings.py; then
    echo Secret key exists
else
    echo Generating new secret key
    python -c "import os; from random import choice; key_line = '%sSECRET_KEY=\"%s\"  # generated from build.sh\n' % ('from tardis.settings_changeme import * \n\n' if not os.path.isfile('tardis/settings.py') else '', ''.join([choice('abcdefghijklmnopqrstuvwxyz0123456789\\!@#$%^&*(-_=+)') for i in range(50)])); f=open('/mytardis_settings/docker_settings.py', 'a+'); f.write(key_line); f.close()"
fi


# need to sleep to make sure that db is ready before syndb runs
# there must be a better way of doing this...

 echo cleaning up pids
    rm -vf /var/run/celery/celerybeat.pid


sleep 30

# run Celery worker for our project myproject with Celery configuration stored in Celeryconf
su -m mytardis -c "python mytardis.py celerybeat --logfile=/logs/celery.log"
