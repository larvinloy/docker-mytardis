#!/bin/bash

main() {

	case "$1" in
		celery)
			run_celery
			;;
		gunicorn)
			run_gunicorn
			;;
		beat)
			run_beat
			;;
		sftp)
			run_sftp
			;;
		store)
			exit 0
			;;
		*)
	    	exec "$@"
	    	;;
	esac
}

run_gunicorn() {
	#cp /logrotate_mytardis.conf /etc/logrotate.d/mytardis
	#chmod 644 /etc/logrotate.d/chiminey
	exec /gunicorn_run.sh
}

run_celery() {
	#cp /logrotate_celery.conf /etc/logrotate.d/celery
	#chmod 644 /etc/logrotate.d/celery
	exec /celery_run.sh
}


run_sftp() {
	exec /sftp_run.sh
}

run_beat() {
	#cp /logrotate_beat.conf /etc/logrotate.d/beat
	#chmod 644 /etc/logrotate.d/beat
	exec /celerybeat_run.sh
}

main "$@"
