import djcelery
from datetime import timedelta
import os

# DB
DATABASES = {
    'default': {
        'ENGINE':'django.db.backends.postgresql_psycopg2',
        'NAME':  os.environ.get('DB_NAME', ''),
        'USER': os.environ.get('DB_USER', ''),
        'PASSWORD': os.environ.get('DB_PASS', ''),
        'HOST': 'db',
        'PORT': os.environ.get('DB_PORT', '5432'),
    },
}


STAGING_PATH = "/staging"
DEFAULT_STORAGE_BASE_DIR = "/store"


# Logging
DEBUG = bool(int(os.environ.get('DJANGO_DEBUG', 0)))
TEMPLATE_DEBUG = DEBUG
SYSTEM_LOG_LEVEL = os.environ.get('SYSTEM_LOG_LEVEL', "DEBUG")
MODULE_LOG_LEVEL = os.environ.get('MODULE_LOG_LEVEL', "DEBUG")
SYSTEM_LOG_FILENAME = '/logs/request.log'
MODULE_LOG_FILENAME = '/logs/tardis.log'


# Message Queue
BROKER_URL ='amqp://{user}:{password}@{hostname}/{vhost}/'.format(
        user=os.environ.get('RABBITMQ_DEFAULT_USER', 'admin'),
        password=os.environ.get('RABBITMQ_DEFAULT_PASS', 'pass'),
        hostname='amqp:5672',
        vhost='')

# Celery
CELERY_RESULT_BACKEND = 'amqp'
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


# Settings for the single search box
SINGLE_SEARCH_ENABLED = bool(os.environ.get('SINGLE_SEARCH_ENABLED', True))
# flip this to turn on search:
if SINGLE_SEARCH_ENABLED:
    HAYSTACK_CONNECTIONS = {
        'default': {
            'ENGINE': 'haystack.backends.elasticsearch_backend.'
                      'ElasticsearchSearchEngine',
            'URL': 'http://haystack:9200/',
            'INDEX_NAME': 'haystack',
        },
    }
HAYSTACK_SIGNAL_PROCESSOR = 'haystack.signals.RealtimeSignalProcessor'


djcelery.setup_loader()
