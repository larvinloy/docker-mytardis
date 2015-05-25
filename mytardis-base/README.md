# http://www.syncano.com/configuring-running-django-celery-docker-containers-pt-1/

# build image
docker build --rm -t="ianedwardthomas/mytardis" .


# create db
docker create --name=dbstore -v /var/lib/postgresql postgres true 
docker run -d --name=db --volumes-from dbstore -e POSTGRES_PASSWORD=mysecretpassword postgres

# create rabbitmq
docker run -d --name=rabbitmq -e RABBITMQ_PASS=pass -p 5672:5672 -p 15672:15672 -h "amqp.local" tutum/rabbitmq
#docker run -d --name=celery --link rabbitmq:rabbit -e CELERY_BROKER_URL=amqp://admin:pass@172.17.0.10// celery

# create celery worker
docker run -d --name=celery --link rabbitmq:rabbitmq --link db:db --volumes-from mytardisstore ianedwardthomas/mytardis /opt/mytardis/webapp/run_celery.sh

# create celery beat
docker run -d --name=celerybeat --link rabbitmq:rabbitmq --link db:db --volumes-from mytardisstore ianedwardthomas/mytardis /opt/mytardis/webapp/run_celerybeat.sh

# create mytardis
docker create --name=mytardisstore -v /var/mytardis/store ianedwardthomas/mytardis true 
docker run -d -p 80:80 --name=mytardis --link rabbitmq:rabbitmq --link db:db -v /var/run/gunicorn/mytardis --volumes-from mytardisstore ianedwardthomas/mytardis

# setup mytardis
docker exec -it mytardis python /opt/mytardis/webapp/mytardis.py createsuperuser
