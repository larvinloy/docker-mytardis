To create the password for kibana run the following commands

```
docker-compose build
docker-compose run htpasswd
```

and restart the kibana and nginx container:

```
docker-compose restart kibana nginx
```
