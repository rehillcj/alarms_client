#!/bin/bash

#echo $1
if [[ -z $1 ]]; then
	exit
fi

source /usr/local/sbin/alarms/dist_list

WAV_ACTIVATE=/usr/local/share/media/ding.wav
WAV_TRIP=/usr/local/share/media/boing.wav

GRACE=`psql -d alarms_mqtt -c "select extract(seconds from grace) from mode where description = 'entry alarm away';" -t -q`

if [ $1 == "active" ]; then
       	echo "The entry alarm is now active in away mode. You now have"$GRACE" seconds to either leave or turn off the alarm." > /tmp/utter.txt
        flite -voice slt < /tmp/utter.txt
	sleep 1
	GRACE_EXPIRED="f"
	while [ $GRACE_EXPIRED == "f" ]; do
		ACTIVE=`psql -d alarms_mqtt -c "select active from mode where description = 'entry alarm away';" -t -q`
		if [ $ACTIVE == "t" ]; then
			paplay $WAV_ACTIVATE
		else exit
		fi
		sleep 5
		GRACE_EXPIRED=`psql -d alarms_mqtt -c "select grace_expired from v_mode where description = 'entry alarm away';" -t -q`
	done;
       	exit
fi

if [ $1 == "inactive" ]; then
        #paplay $WAV
       	echo "The entry alarm is now inactive." > /tmp/utter.txt
        flite -voice slt < /tmp/utter.txt
       	exit
fi

GRACE_EXPIRED=`psql -d alarms_mqtt -c "select grace_expired from v_mode where description = 'entry alarm away';" -t -q`
if [ $GRACE_EXPIRED == "f" ]; then
	exit
fi

i=0
while [ $i -lt $GRACE ]; do
	paplay $WAV_TRIP

	ACTIVE=`psql -d alarms_mqtt -c "select active from mode where description = 'entry alarm away';" -t -q`
	if [ $ACTIVE == "f" ]; then
		exit
	fi

	i=$((i + 1))
	#echo $i
	sleep 1
done;

#echo $ACTIVE

if [ $ACTIVE == "t" ]; then
	#turn on siren
	#psql -d arduino_mqtt -c "update request_dio set d07 = 't' where unit = '14';" -q -t
	#sleep 1
	#psql -d arduino_mqtt -c "update request_dio set d07 = 'f' where unit = '14';" -q -t


	RES=`psql -d alarms_mqtt -c "select sound, notify from mode where description = 'entry alarm away';" -t -q`
	SOUND=`echo $RES | sed 's/ .*//g'`
	NOTIFY=`echo $RES | sed 's/.* //g'`

	if [ $SOUND == 't' ]; then
	        paplay $WAV
	fi

	if [ $NOTIFY == 't' ]; then

		MESSAGE1=`date`
		MESSAGE2="away mode entry alarm triggered at "$1
		echo $MESSAGE1 > /tmp/message.txt
	        echo $MESSAGE2 >> /tmp/message.txt
        	#cat /tmp/message.txt
        	cat /tmp/message.txt | mailx -s "entry alarm (away mode)" $DIST
	fi
fi


exit
