########################################
RABBITPASS=pass
POSTGRESPASS=mysecret
CELERYMON_AUTH=mytardis:${RABBITPASS}
#######################################


REPOS=ianedwardthomas/
#REPOS=
DOCKEROPS = -e http_proxy -e https_proxy
BUILDOPS=--rm
#BUILDOPS=--no-cache --rm

EXTERNAL_PORT=80

default:


build:

	cd mytardis-base && docker build $(BUILDOPS)  -t="$(REPOS)docker-mytardis-base" .
	cd mytardis-celery && docker build $(BUILDOPS) -t="$(REPOS)docker-mytardis-celery" .
	cd mytardis-beat && docker build $(BUILDOPS)  -t="$(REPOS)docker-mytardis-beat" .
	cd mytardis-portal && docker build $(BUILDOPS) -t="$(REPOS)docker-mytardis-portal" .
	cd mytardis-nginx && docker build $(BUILDOPS) -t='$(REPOS)docker-mytardis-nginx' .

kill:
	docker rm -f mytardis celerybeat celery.1 celery.2

run:
	docker run -d --name=rabbitmq $(DOCKEROPS) --volumes-from rabbitmqstore -e RABBITMQ_PASS=$(RABBITPASS) --expose 5672 --expose 15672 -h "amqp.local" tutum/rabbitmq
	docker run -d -v /var/run/docker.sock:/var/run/docker.sock $(DOCKEROPS) --name rabbitmq-amb -e RABBITMQ_PASS=$(RABBITPASS)  cpuguy83/docker-grand-ambassador -name rabbitmq
	docker run -d --name=db $(DOCKEROPS) --volumes-from dbstore -e POSTGRES_PASSWORD=$(POSTGRESPASS) postgres
	sleep 10
	docker run -d --name=celery.1 $(DOCKEROPS) --link rabbitmq-amb:rabbitmq --link db:db --volumes-from mytardisstore $(REPOS)docker-mytardis-celery
	docker run -d --name=celery.2 $(DOCKEROPS) --link rabbitmq-amb:rabbitmq --link db:db --volumes-from mytardisstore $(REPOS)docker-mytardis-celery
	docker run -d --name=celerybeat $(DOCKEROPS) --link rabbitmq-amb:rabbitmq --link db:db --volumes-from mytardisstore $(REPOS)docker-mytardis-beat
	docker run -d --name=mytardis $(DOCKEROPS) --link rabbitmq-amb:rabbitmq --link db:db --volumes-from mytardisstore $(REPOS)docker-mytardis-portal
	docker run -d -p $(EXTERNAL_PORT):80 $(DOCKEROPS) --name=nginx --volumes-from mytardis --link mytardis:mytardis $(REPOS)docker-mytardis-nginx

start:
	docker start db
	docker start rabbitmq
	docker start rabbitmq-amb
	docker start celery.1
	docker start celery.2
	docker start celerybeat
	docker start mytardis
	docker start nginx


stop:
	docker stop db celery.1 celery.2 celerybeat mytardis rabbitmq nginx rabbitmq-amb

remove:
	docker rm -f db celery.1 celery.2 celerybeat mytardis rabbitmq nginx rabbitmq-amb

restart:
	docker restart db celery.1 celery.2 celerybeat mytardis rabbitmq nginx rabbitmq-amb

stores:
	docker create --name=rabbitmqstore $(DOCKEROPS) -v /data/mnesia tutum/rabbitmq true
	docker create --name=dbstore $(DOCKEROPS) -v /var/lib/postgresql postgres true
	docker create --name=mytardisstore   $(DOCKEROPS) -v /store $(REPOS)docker-mytardis-base true
rmstores:
	docker rm -f dbstore mytardisstore rabbitmqstore
setup:
	docker exec -it mytardis python /opt/mytardis/webapp/mytardis.py createsuperuser

monitor:
	docker run -ti -d -p 5555:5555 --name celerymon  $(DOCKEROPS) --link rabbitmq-amb:rabbitmq -e CELERY_BROKER_URL=amqp://admin:${RABBITPASS}@rabbitmq// iserko/docker-celery-flower --basic_auth=$(CELERYMON_AUTH) --broker_api=http://admin:${RABBITPASS}@rabbitmq:15672/api/
