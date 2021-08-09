#!/bin/bash

#echo $1

source /usr/local/sbin/alarms/dist_list

WAV=/usr/local/share/media/doublebell.wav

if [ $1 == 'active' ]; then
        #paplay $WAV
        echo "entry alarm is now active in home mode" > /tmp/utter.txt
        flite -voice slt < /tmp/utter.txt
        exit
fi

if [ $1 == 'inactive' ]; then
        #paplay $WAV
        echo "entry alarm is now inactive" > /tmp/utter.txt
        flite -voice slt < /tmp/utter.txt
        exit
fi

#turn on siren
psql -d arduino_mqtt -c "update request_dio set d07 = 't' where unit = '14';" -q -t
sleep 1
psql -d arduino_mqtt -c "update request_dio set d07 = 'f' where unit = '14';" -q -t


RES=`psql -d alarms_mqtt -c "select sound, notify from mode where description = 'entry alarm home';" -t -q`
SOUND=`echo $RES | sed 's/ .*//g'`
NOTIFY=`echo $RES | sed 's/.* //g'`

if [ $SOUND == 't' ]; then
        paplay $WAV
fi

if [ $NOTIFY == 't' ]; then

	MESSAGE1=`date`
	MESSAGE2="home mode entry alarm triggered at "$1
        echo $MESSAGE1 > /tmp/message.txt
        echo $MESSAGE2 >> /tmp/message.txt
        #cat /tmp/message.txt
        cat /tmp/message.txt | mailx -s "entry alarm (home mode)" $DIST
fi



exit
