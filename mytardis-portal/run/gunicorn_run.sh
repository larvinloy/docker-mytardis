#!/bin/sh
cd /opt/mytardis/webapp


if grep --quiet SECRET_KEY /mytardis_settings/docker_settings.py; then
    echo Secret key exists
else
    echo Generating new secret key
    python -c "import os; from random import choice; key_line = '%sSECRET_KEY=\"%s\"  # generated from build.sh\n' % ('from tardis.settings_changeme import * \n\n' if not os.path.isfile('tardis/settings.py') else '', ''.join([choice('abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)') for i in range(50)])); f=open('/mytardis_settings/docker_settings.py', 'a+'); f.write(key_line); f.close()"
fi


# The below only works for postgres, because mysql uses differnet port
/waitforit.sh -t 240 db:5432 -- echo "db is up"


sleep 30

# for empty databases, sync all and fake migrate, otherwise run a real migration
python mytardis.py syncdb  --noinput
python mytardis.py migrate --fake
python mytardis.py migrate mydata

python mytardis.py createcachetable default_cache
python mytardis.py createcachetable celery_lock_cache
python mytardis.py collectstatic --noinput

python mytardis.py loaddata tardis/apps/mydata/fixtures/default_experiment_schema.json
python mytardis.py loaddata tardis/tardis_portal/fixtures/cc_licenses.json
python mytardis.py loaddata tardis/tardis_portal/fixtures/defaultgroup.json

#starting SSH
#service ssh start
#service sshd start

#starting mytardis
/usr/bin/gunicorn --log-level WARN --log-file /logs/gunicorn.log -c /opt/mytardis/webapp/gunicorn_conf.py -u mytardis -g nginx -b :$GUNICORN_PORT  wsgi:application >> /logs/gunicorn.log  2>&1
