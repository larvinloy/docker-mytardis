Dockerized MyTardis
===================

This is a dockerized build of the 3.7 branch of the Mytardis Data Curation system: http://mytardis.org

Creates an assembly of docker containers that provide the mytardis webportal, persistent tardis store and mysql/postgres db, rabbitmq message broker, two celery workers, and celery monitoring interface, all working on a single host.

The build has three types of configurations
- **postgres**: Uses PostgrSQL db; users are managed via local Django user management only
- **mysql**: Uses MySQL db; users are managed via local Django user management only
- **cas**: Uses MySQL db, users are amanaged via local Django user management and Central Authentication Service (CAS)


Usage
-----

1. Install docker and docker-compose (http://docs.docker.com/compose)

2. Clone `docker-mytardis` repository
  ```
    git clone https://github.com/ianedwardthomas/docker-mytardis.git
  ```
  
3. Configure the mytardis build. The build can be configured as *postgres*, *mysql*, or *cas*. The following configures the build to use PostgreSQL.
  ```
    - cd docker-mytardis
    - ./init postgres
  ```
  
4. Review the passwords in the enviornment sections in the docker-compose.yml and/or docker-compose-published.yml.

5. Start the system in either of the following ways:
   - To start the system from existing images of MyTardis and related components (Recommended):
  ```
    docker-compose -f docker-compose-published.yml  up -d
  ```
  
  - To start the system after building new images of MyTardis and related components (only if you intend to make changes to the `docker-mytardis` codebase):
  ```
    docker-compose up -d
  ```
  
  After a while, the location http://127.0.0.1 will point at the mytardis portal. To watch the celery workers go to: http://127.0.0.1:5555

6. To create a root user:

```  
  docker exec -ti dockermytardis_mytardis_1 python /opt/mytardis/webapp/mytardis.py createsuperuser --user=root
```

This project is working reasonably well as demo, but IS NOT FOR PRODUCTION USE


Acknowledgements
----------------

Grischa for the initial inspiration at https://github.com/grischa/mytardis-docker






