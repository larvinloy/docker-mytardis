#!/bin/sh
cd /opt/mytardis/webapp

#service nginx restart

if grep --quiet SECRET_KEY tardis/settings.py; then
    echo Secret key exists
else
    echo Generating new secret key
    python -c "import os; from random import choice; key_line = '%sSECRET_KEY=\"%s\"  # generated from build.sh\n' % ('from tardis.settings_changeme import * \n\n' if not os.path.isfile('tardis/settings.py') else '', ''.join([choice('abcdefghijklmnopqrstuvwxyz0123456789\\!@#$%^&*(-_=+)') for i in range(50)])); f=open('/opt/mytardis/webapp/tardis/settings.py', 'a+'); f.write(key_line); f.close()"
fi

# for empty databases, sync all and fake migrate, otherwise run a real migration
python mytardis.py syncdb --all --noinput
python mytardis.py migrate --fake
python mytardis.py createcachetable default_cache
python mytardis.py createcachetable celery_lock_cache
python mytardis.py collectstatic --noinput

#/usr/bin/gunicorn --log-level DEBUG --log-file /logs/gunicorn.log -c /opt/mytardis/webapp/gunicorn_conf.py -u mytardis -g nginx -b unix:/var/run/gunicorn/mytardis/socket wsgi:application >> /logs/gunicorn.log  2>&1
/usr/bin/gunicorn --log-level DEBUG --log-file /logs/gunicorn.log -c /opt/mytardis/webapp/gunicorn_conf.py -u mytardis -g nginx -b :8000 wsgi:application >> /logs/gunicorn.log  2>&1

