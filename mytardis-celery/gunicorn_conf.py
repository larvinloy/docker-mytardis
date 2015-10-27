import multiprocessing
import os

workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "gevent"
timeout = 1800  # half an hour
chdir = os.path.dirname(__file__)
proc_name = "mytardis_gunicorn"


#import os

#os.environ['DJANGO_SETTINGS_MODULE'] = 'tardis.settings'

#import django.core.handlers.wsgi
#application = django.core.handlers.wsgi.WSGIHandler()
