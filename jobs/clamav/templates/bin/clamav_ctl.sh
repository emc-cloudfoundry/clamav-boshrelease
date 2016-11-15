#!/bin/sh
export PKG_LOC=/var/vcap/packages/clamav

LOG_DIR=/var/vcap/sys/log/clamav
RUN_DIR=/var/vcap/sys/run/clamav

if [ ! -d "${LOG_DIR}" ]; then
	mkdir -p ${LOG_DIR}
	touch ${LOGDIR}/freshclam.log
	touch ${LOG_DIR}/clamav.log
fi

if [ ! -d "${RUN_DIR}" ]; then
	mkdir -p ${RUN_DIR}
fi

case "$1" in
	'start_clamd')
	  $PKG_LOC/sbin/clamd -c /var/vcap/jobs/clamav/conf/clamd.conf
	  sleep 1
	;;
	'start_freshclam')
	  $PKG_LOC/bin/freshclam -d --config-file /var/vcap/jobs/clamav/conf/freshclam.conf
	;;
	'stop_clamd')
	  kill -9 `pidof clamd`
	;;
	'stop_freshclam')
	  kill -9 `pidof freshclam`
	;;
esac
