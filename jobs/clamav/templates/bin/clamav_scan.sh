#!/bin/bash

# Directories to scan
SCAN_DIR="/home /tmp /var"

# Location of log file
LOG_FILE="/var/vcap/sys/log/clamav/clamscan.log"

# Value of 0 will not remove files
# Value of 1 will remove files
AGGRESSIVE=0

# Value of 0 will not send an email upon discovery
# Value of 1 will send a summary email upon discovery
SEND_EMAIL=0

# Email Subject
SUBJECT="Infections detected on `hostname`"
# Email To
EMAIL="your.email@your.domain.com"
# Email From
EMAIL_FROM="clamav@server.hostname.com"

check_scan () {
    # If there were infected files detected, send email alert
 
    if [[ `tail -n 12 ${LOG_FILE}  | grep Infected | grep -v 0 | wc -l` != 0 ]]
    then
    # Count number of infections
        SCAN_RESULTS=$(tail -n 10 $LOG_FILE | grep 'Infected files')
        INFECTIONS=${SCAN_RESULTS##* }
 
        EMAILMESSAGE=`mktemp /tmp/virus-alert.XXXXX`
        echo "To: ${EMAIL}" >>  ${EMAILMESSAGE}
        echo "From: ${EMAIL_FROM}" >>  ${EMAILMESSAGE}
        echo "Subject: ${SUBJECT}" >>  ${EMAILMESSAGE}
        echo "Importance: High" >> ${EMAILMESSAGE}
        echo "X-Priority: 1" >> ${EMAILMESSAGE}

        if [[ $AGGRESSIVE -eq 1 ]]
        then
            echo -e "\n`tail -n $((10 + ($INFECTIONS*2))) $LOG_FILE`" >> ${EMAILMESSAGE}
        else
            echo -e "\n`tail -n $((10 + $INFECTIONS)) $LOG_FILE`" >> ${EMAILMESSAGE}
        fi

        sendmail -t < ${EMAILMESSAGE}
    fi
}

# Ensure a previous scan is not still running
running=`pgrep clamscan`
if [[ $? -eq 0 ]]
then
    echo "don't run because process already running - pid $running" 1>&2
    exit 1
fi

if [[ $AGGRESSIVE -eq 1 ]]
then
    /var/vcap/packages/clamav/bin/clamscan -ri --exclude-dir=^/sys\|^/proc\|^/dev --remove $SCAN_DIR >> $LOG_FILE
else
    /var/vcap/packages/clamav/bin/clamscan -ri --exclude-dir=^/sys\|^/proc\|^/dev $SCAN_DIR >> $LOG_FILE
fi

if [[ $SEND_EMAIL -eq 1 ]]
then
    check_scan
fi

exit 0