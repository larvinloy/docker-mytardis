#!/bin/sh

echo This script creates a self-signed certificates for mytardis access.  For real certificates, add these to the nginx container configuration.

if [ -f /opt/certs/mytardis.crt  ]; then \
    echo Failed: this script will not overwrite existing certificates.  Remove the existing certs from the ./certs directory and then rerun this command.
    exit 0
fi

openssl req -x509 -nodes -newkey rsa:2048 -keyout /opt/certs/mytardis.key -out /opt/certs/mytardis.crt
