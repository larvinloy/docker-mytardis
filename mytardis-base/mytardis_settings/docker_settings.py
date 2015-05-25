import djcelery
from datetime import timedelta
import os

DATABASES = {
    'default': {
        'ENGINE':'django.db.backends.postgresql_psycopg2',
        'NAME': os.environ.get('DB_ENV_DB', 'postgres'),
        'USER': os.environ.get('DB_ENV_POSTGRES_USER', 'postgres'),
        'PASSWORD': os.environ.get('DB_ENV_POSTGRES_PASSWORD', ''),
        'HOST': os.environ.get('DB_PORT_5432_TCP_ADDR', ''),
        'PORT': os.environ.get('DB_PORT_5432_TCP_PORT', ''),
    },
}

#CELERY_BROKER_URL=os.environ.get('CELERY_ENV_CELERY_BROKER_URL','django://')
#BROKER_URL=os.environ.get('CELERY_ENV_CELERY_BROKER_URL','django://')

CELERY_RESULT_BACKEND = 'amqp'

STAGING_PATH = "/staging"
DEFAULT_STORAGE_BASE_DIR = "/store"

#CELERY_BROKER_URL="amqp://%s@%s:5672/" % (os.environ.get('RABBITMQ_PORT_5672_TC_ADDR',''),
#	os.environ.get('RABBITMQ_ENV_RABBITMQ_PASS',''))
#BROKER_URL=CELERY_BROKER_URL

RABBITMQ_HOSTNAME = os.environ.get('RABBITMQ_PORT_5672_TCP', 'localhost:5672')
 
if RABBITMQ_HOSTNAME.startswith('tcp://'):
	RABBITMQ_HOSTNAME = RABBITMQ_HOSTNAME.split('//')[1]
 
BROKER_URL = os.environ.get('BROKER_URL',
	'')
if not BROKER_URL:
	BROKER_URL = 'amqp://{user}:{password}@{hostname}/{vhost}/'.format(
		user=os.environ.get('RABBITMQ_ENV_USER', 'admin'),
		password=os.environ.get('RABBITMQ_ENV_RABBITMQ_PASS', 'mypass'),
		hostname=RABBITMQ_HOSTNAME,
		vhost=os.environ.get('RABBITMQ_ENV_VHOST', ''))

SYSTEM_LOG_LEVEL = 'DEBUG'
MODULE_LOG_LEVEL = 'DEBUG'


CELERYBEAT_SCHEDULE = {
    "verify-files": {
        "task": "tardis_portal.verify_dfos",
        "schedule": timedelta(seconds=30)
    },
    # enable this task for the publication workflow
    # "update-publication-records": {
    #     "task": "tardis_portal.update_publication_records",
    #     "schedule": timedelta(seconds=300)
    # },
}

djcelery.setup_loader()
