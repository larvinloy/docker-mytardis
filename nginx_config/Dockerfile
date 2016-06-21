FROM debian:jessie

MAINTAINER Ian Thomas <ianedwardthomas@gmail.com>

RUN apt-get update && apt-get install -y apache2-utils

ENTRYPOINT ["htpasswd", "-c", "/htpasswd/kibana.htpasswd", "mytardis"]
