#!/bin/bash

# Check if no parameter is given
if [ -z "$1" ]
  then echo "This script generates the first SSL certificate. Pass config file as first parameter."
  echo "Example: sudo ./02_generate.sh example.config"
  echo "If you want to test the script, add --dry-run as second parameter."
  exit
fi

# Check if sudo rights
if [ "$EUID" -ne 0 ]
  then echo "Please run script as root (sudo ./02_generate.sh example.config) for mounting remote FTP server."
  exit
fi

# array with two strings "abc" "def"
CONFIGS=("DOMAINS" "EMAIL" "FTPSERVER" "FTPPORT" "FTPPATH" "FTPUSER" "FTPPWD")

# Check if given config file exists
if [ ! -f $1 ]
  then echo "Config file $1 does not exist."
  exit
fi

# Read config file
source $1

# Check if all config variables are set
for i in "${CONFIGS[@]}"
do
  if [ -z "${!i}" ]
	then echo "Please set $i in config file."
	exit
  fi
done

# Check if FTPPATH ends with /
if [ "${FTPPATH: -1}" != "/" ]
  then echo "Please set FTPPATH in config file to end with a slash."
  exit
fi

# certbot command
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CERTBOT="certbot certonly --manual --preferred-challenges http --agree-tos --manual-public-ip-logging-ok -m '$EMAIL' --manual-auth-hook $DIR/hook-auth.sh --manual-cleanup-hook $DIR/hook-cleanup.sh -d '$DOMAINS'"

# check if --dry-run
if [ "$2" == "--dry-run" ]
  then CERTBOT="$CERTBOT --dry-run"
fi

# check if user is ok with CERTBOT command
echo "Do you want to run the following command (y/N)?"
echo 
read -p "$CERTBOT" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
	$CERTBOT
else
	echo "Aborting..."
	exit
fi
