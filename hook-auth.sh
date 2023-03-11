#!/bin/bash

# # check if one parameter is given
# if [ -z "$1" ]
#   then echo "Error: Missing config file as first parameter."
#   exit
# fi

# # load config file from first parameter
# source $1

# get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FTP_MOUNT_DIR="$DIR/remote_ftp"

# check if root
if [ "$EUID" -ne 0 ]
  then echo "Error: Please run as root."
  exit
fi

# check if CurlFtpFS is installed, abort otherwise
if [ ! -f /usr/bin/curlftpfs ]
  then echo "Error: CurlFtpFS is not installed."
  exit
fi

# check if all certbot environment variables are set
EXPECTED_ENV=("CERTBOT_DOMAIN" "CERTBOT_VALIDATION" "CERTBOT_TOKEN" "CERTBOT_REMAINING_CHALLENGES" "CERTBOT_ALL_DOMAINS")
for i in "${EXPECTED_ENV[@]}"
do
  if [ -z "${!i}" ]
	then echo "Error: Missing $i environment variable from certbot. Please don't use this script manually."
	exit
  fi
done

# check if FTP_MOUNT_DIR already exists
if [ -d "$FTP_MOUNT_DIR" ]
  then
  	# check if FTP_MOUNT_DIR is not empty
  	if [ "$(ls -A $FTP_MOUNT_DIR)" ]
  	  then echo "Error: $FTP_MOUNT_DIR already exists. Delete it first."
  	  exit
  	fi

  	# check if anything is mounted to FTP_MOUNT_DIR
  	if [ "$(mount | grep $FTP_MOUNT_DIR)" ]
  	  then echo "Error: $FTP_MOUNT_DIR is already mounted. Unmount it first."
  	  exit
  	fi
fi

# make FTP_MOUNT_DIR
mkdir $FTP_MOUNT_DIR

# mount FTP server to FTP_MOUNT_DIR
curlftpfs ftp://$FTPUSER:$FTPPWD@$FTPSERVER:$FTPPORT$FTPPATH $FTP_MOUNT_DIR

# Write acme challange into remote file
echo $CERTBOT_VALIDATION > $FTP_MOUNT_DIR/$CERTBOT_TOKEN

