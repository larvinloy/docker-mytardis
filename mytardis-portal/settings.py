from tardis.settings_changeme import *

INSTALLED_APPS += ('tardis.apps.mydata',) 

# required workaround for mytardis 3.7 bug
INSTALLED_APPS = ['tardis.tardis_portal'] + [x for x in INSTALLED_APPS if not x == 'tardis.tardis_portal']
 
import sys
sys.path.append('/mytardis_settings')

try:
    from docker_settings import *
except:
    print 'no Docker specific MyTardis settings available'
    raise
