#!/bin/bash

hash='PASSWORD HASH GOES HERE'
echo 'Entre ton MDP: '
try=3

while true; do
	read -s -p ' ' MYMDP
	userhash=$(openssl passwd -6 -salt SALTNAME $MYMDP)
	if [ $userhash == $hash ]; then
		echo 'mdp ok'
		break
	else
		echo 'Mauvais mot de passe, recommence: '
		let try-=1
		if [ $try -eq 0 ]; then
			echo "Nombre de tentative dépassé !!"
			exit 1
		fi
	fi
done

#if [ $hash == $(openssl passwd -6 -salt SALTNAME $MYMDP) ]; then
#	echo 'OK'
#else
#	echo 'NOK'
#fi
