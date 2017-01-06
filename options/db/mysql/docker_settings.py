import djcelery
from datetime import timedelta
import os


DATABASES = {
    'default': {
        'ENGINE':'django.db.backends.mysql',
        'NAME': os.environ.get('DB_NAME', ''),
        'USER': os.environ.get('DB_USER', ''),
        'PASSWORD': os.environ.get('DB_PASS', ''),
        'HOST': 'db',
        'PORT': 3306,
        'STORAGE_ENGINE': 'InnoDB',
        'OPTIONS': {
            #'init_command': 'SET storage_engine=InnoDB',
            'init_command': 'SET default_storage_engine=InnoDB',
            'charset': 'utf8',
            'use_unicode': True,
        },
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

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'system': {
            'format': '[%(asctime)s] %(levelname)-7s %(ip)-15s %(user)s %(method)s %(message)s %(status)s',
            'datefmt': '%d/%b/%Y %H:%M:%S',
        },
        'module': {
            'format': '[%(asctime)s] %(levelname)-7s %(module)s %(funcName)s %(message)s',
            'datefmt': '%d/%b/%Y %H:%M:%S',
        },
    },
    'handlers': {
        'systemlog': {
            'class': 'logging.StreamHandler',
            'formatter': 'system',
        },
        'modulelog': {
            'class': 'logging.StreamHandler',
            'formatter': 'module',
        },
    },
    'loggers': {
        __name__: {
            'handlers': ['systemlog'],
            'propagate': False,
            'level': SYSTEM_LOG_LEVEL,
        },
        'tardis': {
            'handlers': ['modulelog'],
            'propagate': False,
            'level': MODULE_LOG_LEVEL,
        },
    }
}

NEW_USER_INITIAL_GROUPS = ["Users"]

djcelery.setup_loader()
