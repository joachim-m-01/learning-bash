#!/bin/bash

# Sander Van Vught exercice LFCS

COUNTER=$1
COUNTER=$(( COUNTER * 60 ))

minusone(){

	COUNTER=$(( COUNTER - 1 ))
	sleep 1

}
while [ $COUNTER -gt 0 ]
do
	echo "You still have $COUNTER second left ! "
	minusone
done

[ $COUNTER = 0 ] && echo 'time up !'
[ $COUNTER = '-1' ] && echo you are one second late && minusone

while  true
do
	echo -e  "you are ${COUNTER#-} second late"
	minusone
done
