#! /bin/bash
if [[ $# -eq 0 ]]; then
	echo "Besoin d'un argument"
	exit 1
fi
for u in $*
do
	cut -d':' -f1 /etc/passwd | grep -q $u
	if (($? != 0 )); then
		echo -e "$u n'est pas un utilisateur valide"
		continue
	fi
procs=$(ps -u $u | wc -l )
nbproc=$(( $procs - 1))
	if (( $nbproc > 1 )); then
		echo -e "$u a $nbproc processus d'actif"

	elif (( $nbproc == 0 )); then

		echo -e "$u n'a aucun processus d'actif"
	else
		echo 'KO'
	fi
done
