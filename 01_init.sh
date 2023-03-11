#!/bin/bash

# check if first parameter is ok
if [ "$1" != "install" ]
  then 
  	echo "This script installs curlftpfs if not already installed."
  	echo "Run sudo ./init.sh install."
  exit
fi

# check if CurlFtpFS is already installed
if [ -f /usr/bin/curlftpfs ]
  then echo "CurlFtpFS is already installed"
  exit
fi


# check if root rights
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
