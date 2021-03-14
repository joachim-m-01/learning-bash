#!/bin/sh

# -- Variable couleurs
rd='\e[31m'
gn='\e[32m'
yl='\e[93m'

# -- Variable specifique

kdepath='/usr/bin/kdeconnect-app'
fwzone=$(firewall-cmd --get-default-zone)
fwport='1714-1764'

if [ $EUID -ne '0' ]
then
  echo -e "$rd You must be root to execute this script"
  exit 1
fi

function enable() {
    firewall-cmd --zone=$fwzone --permanent --add-port=1714-1764/tcp
    firewall-cmd --zone=$fwzone --permanent --add-port=1714-1764/udp
    firewall-cmd --reload
}

function checkzone() {
  if [ $fwzone != 'home' ]
  then
    echo -e "$yl Be careful, you are not in a trusted zone"
    while true; do
    read -p "Do you want to continue? " ask

    case $ask in
      [Yy] ) echo -e "$yl Configuring firewall rules on $fwzone zone !"; enable ; exit 0;;
      [Nn] ) echo -e "$yn Good choice" ; exit 2 ;;
      * ) echo -e "$yl Only Yy or Nn"
    esac
  done
  elif [ $fwzone = 'home' ]
  then
    enable
fi
}

function disable() {
firewall-cmd --zone=$fwzone --list-ports | grep -q $fwport
  if [ $? -eq '0' ]
  then
    firewall-cmd --zone=$fwzone --permanent --remove-port=1714-1764/tcp
    firewall-cmd --zone=$fwzone --permanent --remove-port=1714-1764/udp
    firewall-cmd --reload
    echo -e "$gn kdeconnect port removed ! "
  else
    echo -e "$rd ports not found"
fi
  pkill kdeconnect
}

function usage() {
  echo
  echo "|---------------------------------------------------|"
  echo "Options:"
  echo "  -e: Check firewall zone and enable kdeconnect ports"
  echo "  -d: Disable firewall ports and kill kdeconnect"
  echo "|---------------------------------------------------|"
  exit 0
}
if [[ $1 == "" ]]; then
  usage
  exit 0
fi
while getopts 'hed' opt
  do
    case $opt in
      h) usage;;
      e) checkzone;;
      d) disable;;
      *) echo "show usage $0 [-h]" >&2; exit 0;;
    esac

  done
