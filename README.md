Dockerized MyTardis
===================

This is a dockerized build of the development branch of the Mytardis Data Curation system: http://mytardis.org

Creates an assembly of docker containers that provide the mytardis webportal, persistent tardis store and postgres db, rabbitmq message broker, two celery workers, and celery monitoring interface, all working on a single host.

Usage
-----

1. Install docker (http://docker.com) and connect to your host as usual.

2. Review the first few lines of the Makefile and change passwords from default.

3. To make the persistent backend stores:

```
  	make stores 
```

4. To start the system:

```
  	make run
```

After a while, the location http://127.0.0.1 will point at the mytardis portal.

5. To create a root user::

```  
	make setup
```

6. To watch the celery workers::

``` 
	make monitor
```

   The monitor is at http://127.0.0.1:5555

See the Makefile for more information.

This project is working reasonably well as demo, but IS NOT FOR PRODUCTION USE


Acknowledgements
----------------

Grischa for the initial inspiration at https://github.com/grischa/mytardis-docker






