#!/bin/bash

#echo $1

source /usr/local/sbin/alarms/dist_list

WAV=/usr/local/share/media/singlebell.wav

if [ $1 == 'active' ]; then
        #paplay $WAV
        #echo "door chiming is now active" > /tmp/utter.txt
        #flite -voice slt < /tmp/utter.txt
        exit
fi

if [ $1 == 'inactive' ]; then
        #paplay $WAV
        #echo "door chiming is now inactive" > /tmp/utter.txt
        #flite -voice slt < /tmp/utter.txt
        exit
fi

RES=`psql -d alarms_mqtt -c "select sound, notify from mode where description = 'door close';" -t -q`
SOUND=`echo $RES | sed 's/ .*//g'`
NOTIFY=`echo $RES | sed 's/.* //g'`

if [ $SOUND == 't' ]; then
        paplay $WAV
fi

if [ $NOTIFY == 't' ]; then
        echo $1 | mailx -s "door close" $DIST
fi

exit
