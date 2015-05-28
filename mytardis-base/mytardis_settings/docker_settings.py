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


CELERY_RESULT_BACKEND = 'amqp'

STAGING_PATH = "/staging"
DEFAULT_STORAGE_BASE_DIR = "/store"


BROKER_URL ='amqp://{user}:{password}@{hostname}/{vhost}/'.format(
        user='admin',
        password=os.environ.get('RABBITMQ_ENV_RABBITMQ_PASS', 'mypass'),
        hostname='rabbitmq:5672',
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
