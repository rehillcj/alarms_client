#!/bin/bash

#echo $1

source /usr/local/sbin/alarms/dist_list

WAV=/usr/local/share/media/doublebell.wav

if [ $1 == 'active' ]; then
        #paplay $WAV
        echo "the house temperature monitor and alarm is now active." > /tmp/utter.txt
        flite -voice slt < /tmp/utter.txt
        exit
fi

if [ $1 == 'inactive' ]; then
        #paplay $WAV
        echo "the house temperature monitor and alarm is now inactive." > /tmp/utter.txt
        flite -voice slt < /tmp/utter.txt
        exit
fi


RES=`psql -d alarms_mqtt -c "select sound, notify from mode where description = 'temperature alarm';" -t -q`
SOUND=`echo $RES | sed 's/ .*//g'`
NOTIFY=`echo $RES | sed 's/.* //g'`

#echo $SOUND
#echo $NOTIFY

if [ $SOUND == 't' ]; then
        paplay $WAV
fi

if [ $NOTIFY == 't' ]; then
	SQL="select round(state) from sensor where description = '"$1"';"
	STATE=`psql -d alarms_mqtt -c "$SQL" -t -q`
	#echo $STATE
	
	SQL="select trip_lo from v_event_sensor where sensor_description = '"$1"';"
	TL=`psql -d alarms_mqtt -c "$SQL" -t -q`
	#echo $TL

	SQL="select trip_hi from v_event_sensor where sensor_description = '"$1"';"
	TH=`psql -d alarms_mqtt -c "$SQL" -t -q`
	#echo $TH

	if [ $STATE -lt $TL ]; then	
		CONDITION="low"
	fi
	if [ $STATE -gt $TH ]; then
		CONDITION="high"
	fi

	MESSAGE1=`date`
	MESSAGE2=$1" is out of bounds on the "$CONDITION" side."
        echo $MESSAGE1 > /tmp/message.txt
        echo $MESSAGE2 >> /tmp/message.txt
        #cat /tmp/message.txt
        cat /tmp/message.txt | mailx -s "temperature alarm" $DIST
fi

exit
