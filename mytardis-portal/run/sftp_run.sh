#!/bin/bash


main() {

    cd /opt/mytardis/webapp

    if grep --quiet SECRET_KEY /mytardis_settings/docker_settings.py; then
        echo Secret key exists
    else
        echo Generating new secret key
        python -c "import os; from random import choice; key_line = '%sSECRET_KEY=\"%s\"  # generated from build.sh\n' % ('from tardis.settings_changeme import * \n\n' if not os.path.isfile('tardis/settings.py') else '', ''.join([choice('abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)') for i in range(50)])); f=open('/mytardis_settings/docker_settings.py', 'a+'); f.write(key_line); f.close()"
    fi

    function clean_up {
        echo cleaning up...
    }


    clean_up

    # need to sleep to make sure that db is ready before sftp runs
    # there must be a better way of doing this...
    echo sleeping...
    sleep 30


    echo starting...

    trap clean_up SIGTERM

    # run Celery worker for our project myproject with Celery configuration stored in Celeryconf
    su -m mytardis -c "python mytardis.py sftpd -H sftp"

    # echo "waiting..."
    # tail -f /dev/null

    clean_up

    echo "sftp is done..."
}


main "$@"
