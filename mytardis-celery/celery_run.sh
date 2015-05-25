#!/bin/sh
  
cd /opt/mytardis/webapp

python -c "import os; from random import choice; key_line = '%sSECRET_KEY=\"%s\"  # generated from build.sh\n' % ('from tardis.settings_changeme import * \n\n' if not os.path.isfile('tardis/settings.py') else '', ''.join([choice('abcdefghijklmnopqrstuvwxyz0123456789\\!@#$%^&*(-_=+)') for i in range(50)])); f=open('tardis/settings.py', 'a+'); f.write(key_line); f.close()"

# run Celery worker for our project myproject with Celery configuration stored in Celeryconf
su -m mytardis -c "python mytardis.py celery worker --loglevel=INFO"
