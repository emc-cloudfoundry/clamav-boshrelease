#!/bin/sh
export PKG_LOC=/var/vcap/packages/clamav

cp /var/vcap/jobs/clamav/conf/freshclam.conf $PKG_LOC/etc/freshclam.conf 
cp /var/vcap/jobs/clamav/conf/clamd.conf $PKG_LOC/etc/clamd.conf 
#
# /etc/init.d/daemon-clamd is not needed anymore and may be present when upgrading an earlier deployment
if [ -f /etc/init.d/daemon-clamd ]
then
  rm -f /etc/init.d/daemon-clamd
fi

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
if [ ! -d "/var/lib/clamav" ]; then
	mkdir -p /var/lib/clamav
fi

# Copy virus definitions if it is not there already
if [ ! -f /var/lib/clamav/main.cvd ]; then
	cp $PKG_LOC/virus_defs/main.cvd /var/lib/clamav/
	cp $PKG_LOC/virus_defs/daily.cvd /var/lib/clamav/
	cp $PKG_LOC/virus_defs/bytecode.cvd /var/lib/clamav/
fi

case "$1" in
	'start_clamd')
	  $PKG_LOC/sbin/clamd -c $PKG_LOC/etc/clamd.conf
	  (crontab -l | sed /clamav.*scan/d; cat /var/vcap/jobs/clamav/conf/clamav_dailyscan.cron) | sed /^$/d | crontab
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
