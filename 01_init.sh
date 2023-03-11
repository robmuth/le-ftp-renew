#!/bin/bash

# check if first parameter is ok
if [ "$1" != "install" ]
  then 
  	echo "This script installs curlftpfs if not already installed."
  	echo "Run sudo ./init.sh install."
  exit
fi

# check if CurlFtpFS is already installed, install if not
if [ ! -f /usr/bin/curlftpfs ]
  then 
  	sudo apt-get install curlftpfs
  	modprobe fuse
  exit
fi

# check if root rights
if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

# check if script files have execute rights (chmod +x), if not give so
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPTS=("02_generate.sh" "hook-auth.sh" "hook-cleanup.sh" "hook-unmount.sh" "hook-deploy.sh")
for i in "${SCRIPTS[@]}"
do
  if [ ! -x "$DIR/$i" ]
	then chmod +x "$DIR/$i"
  fi
done
