Dockerized MyTardis
===================

This is a dockerized build of the 3.6 branch of the Mytardis Data Curation system: http://mytardis.org

Creates an assembly of docker containers that provide the mytardis webportal, persistent tardis store and mysql/postgres db, rabbitmq message broker, two celery workers, and celery monitoring interface, all working on a single host.

Usage
-----

1. Install docker and docker-compose (http://docs.docker.com/compose)

2. Review the passwords in the enviornment sections in the docker-compose.xml

3. To start the system:

```
  	docker-compose up -d
```

After a while, the location http://127.0.0.1 will point at the mytardis portal.
To watch the celery workers go to: http://127.0.0.1:5555

4. To create a root user::

```  
  docker exec -ti dockermytardis_mytardis_1 python /opt/mytardis/webapp/mytardis.py createsuperuser --user=root
```
This project is working reasonably well as demo, but IS NOT FOR PRODUCTION USE


Acknowledgements
----------------

Grischa for the initial inspiration at https://github.com/grischa/mytardis-docker






