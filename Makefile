########################################
RABBITPASS=pass
POSTGRESPASS=mysecret
CELERYMON_AUTH=mytardis:${RABBITPASS}
#######################################


REPOS=ianedwardthomas/

default:
	

build:

	cd mytardis-base && docker build --rm -t="$(REPOS)docker-mytardis-base" .
	cd mytardis-celery && docker build --rm -t="$(REPOS)docker-mytardis-celery" .
	cd mytardis-beat && docker build --rm -t="$(REPOS)docker-mytardis-beat" .
	cd mytardis-portal && docker build --rm -t="$(REPOS)docker-mytardis-portal" .
	cd mytardis-nginx && docker build --rm -t='$(REPOS)docker-mytardis-nginx' .

kill:
	docker rm -f mytardis celerybeat celery.1 celery.2

run:
	docker run -d --name=db --volumes-from dbstore -e POSTGRES_PASSWORD=$(POSTGRESPASS) postgres
	docker run -d --name=rabbitmq -e RABBITMQ_PASS=$(RABBITPASS) -p 5672:5672 -p 15672:15672 -h "amqp.local" tutum/rabbitmq
	sleep 10
	docker run -d --name=celery.1 --link rabbitmq:rabbitmq --link db:db --volumes-from mytardisstore $(REPOS)docker-mytardis-celery
	docker run -d --name=celery.2 --link rabbitmq:rabbitmq --link db:db --volumes-from mytardisstore $(REPOS)docker-mytardis-celery
	docker run -d --name=celerybeat --link rabbitmq:rabbitmq --link db:db --volumes-from mytardisstore $(REPOS)docker-mytardis-beat
	docker run -d --name=mytardis --link rabbitmq:rabbitmq --link db:db --volumes-from mytardisstore $(REPOS)docker-mytardis-portal
	docker run -d -p 80:80 --name=nginx --volumes-from mytardis --link mytardis:mytardis $(REPOS)docker-mytardis-nginx

start:
	docker start db
	docker start rabbitmq
	docker start celery.1
	docker start celery.2
	docker start celerybeat
	docker start mytardis
	docker start nginx

stop:
	docker stop db celery.1 celery.2 celerybeat mytardis rabbitmq nginx

remove:
	docker rm -f db celery.1 celery.2 celerybeat mytardis rabbitmq nginx

restart:
	docker restart db celery.1 celery.2 celerybeat mytardis rabbitmq nginx

stores:
	docker create --name=dbstore -v /var/lib/postgresql postgres true
	docker create --name=mytardisstore -v /store $(REPOS)docker-mytardis-base true
rmstores:
	docker rm -f dbstore mytardisstore
setup:
	docker exec -it mytardis python /opt/mytardis/webapp/mytardis.py createsuperuser

monitor:
	docker run -ti -d -p 5555:5555 --name celerymon  --link rabbitmq:rabbitmq -e CELERY_BROKER_URL=amqp://admin:${RABBITPASS}@rabbitmq// iserko/docker-celery-flower --basic_auth=$(CELERYMON_AUTH)
