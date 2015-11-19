import djcelery
from datetime import timedelta
import os

DATABASES = {
    'default': {
        'ENGINE':'django.db.backends.mysql',
        'NAME': os.environ.get('DB_ENV_MYSQL_DATABASE', ''),
        'USER': os.environ.get('DB_ENV_MYSQL_USER', ''),
        'PASSWORD': os.environ.get('DB_ENV_MYSQL_PASSWORD', ''),
        'HOST': os.environ.get('DB_PORT_3306_TCP_ADDR', ''),
        'PORT': os.environ.get('DB_PORT_3306_TCP_PORT', ''),
        'STORAGE_ENGINE': 'InnoDB',
        'OPTIONS': {
            #'init_command': 'SET storage_engine=InnoDB',
            'charset': 'utf8',
            'use_unicode': True,
        },
    },
}


CELERY_RESULT_BACKEND = 'amqp'

STAGING_PATH = "/staging"
DEFAULT_STORAGE_BASE_DIR = "/store"


BROKER_URL ='amqp://{user}:{password}@{hostname}/{vhost}/'.format(
        user='admin',
        password=os.environ.get('RABBITMQ_ENV_RABBITMQ_PASS', 'mypass'),
        hostname='rabbitmq:5672',
        vhost='')

SYSTEM_LOG_LEVEL = 'DEBUG'
MODULE_LOG_LEVEL = 'DEBUG'

SYSTEM_LOG_FILENAME = '/logs/request.log'
MODULE_LOG_FILENAME = '/logs/tardis.log'

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
