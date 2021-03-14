#!/bin/sh

# Script permettant de mettre à jour opensuse
rd=$(tput setaf 1)
gn=$(tput setaf 2)
yl=$(tput setaf 3)
rst=$(tput sgr0)


nb=0
nb=$(zypper lu 2> /dev/null  | sed '1,3d' | wc -l)

if [ $EUID -ne '0' ]; then
	echo -e "$rd You need to be root $rst"
	exit 1
fi
echo -e "${yl} Refreshing repository, please wait . . .${rst}"
zypper refresh 1> /dev/null 2>&1


zypper lu 2> /dev/null ; echo -e "$yn Number of update: $nb $rst"


while [ "$nb" -gt 0 ]  ; do
	# Par defaut la variable ask répondra 'y' si aucune valeur n'a été entrée.
	echo -e "$yn Do you want to continue: [Y/n] $rst"
	read ask
		case ${ask:-'y'} in
			[Yy] ) zypper dup -y && echo -e "$gn System up to date ... $rst" && echo -e "$yn Service need to be rebooted $rst" ; zypper ps -s | sed '1d' | sed 's/^[A-Za-z].*$//g' | sed '/^[[:space:]]*$/d' && exit 0 || echo "error while updating system" && exit 3 ;;

			[Nn] ) echo "exit script with code 0" ; exit 0 ;;

			* ) echo -e "$yn Only Y or N $rst"
		esac
	done
