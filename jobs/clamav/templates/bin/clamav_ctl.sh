#!/bin/sh
export PKG_LOC=/var/vcap/packages/clamav

cp /var/vcap/jobs/clamav/conf/freshclam.conf $PKG_LOC/etc/freshclam.conf 
cp /var/vcap/jobs/clamav/conf/clamd.conf $PKG_LOC/etc/clamd.conf 
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
	  $PKG_LOC/sbin/clamd -c $PKG_LOC/etc/clamd.conf
	  sleep 1
	;;
	'start_freshclam')
	  $PKG_LOC/bin/freshclam -d --config-file $PKG_LOC/etc/freshclam.conf
	;;
	'stop_clamd')
	  kill `pidof clamd`
	;;
	'stop_freshclam')
	  kill `pidof freshclam`
	;;
esac
