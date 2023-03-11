#!/bin/bash

# check if one parameter is given
if [ -z "$1" ]
  then echo "Error: Missing config file as first parameter."
  exit
fi

# load config file from first parameter
source $1

# get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FTP_MOUNT_DIR="$DIR/remote_ftp"

# check if root
if [ "$EUID" -ne 0 ]
  then echo "Error: Please run as root."
  exit
fi

# Check if remote file exists $FTP_MOUNT_DIR/$CERTBOT_TOKEN
if [ ! -f "$FTP_MOUNT_DIR/$CERTBOT_TOKEN" ]
  then echo "Error: Remote file $FTP_MOUNT_DIR/$CERTBOT_TOKEN does not exist."
  exit
fi

# Remove remote file
rm $FTP_MOUNT_DIR/$CERTBOT_TOKEN

# Unmount FTP_MOUNT_DIR
fusermount -u $FTP_MOUNT_DIR

# check if FTP_MOUNT_DIR directory is empty
if [ "$(ls -A $FTP_MOUNT_DIR)" ]
  then echo "Error: $FTP_MOUNT_DIR is not empty."
  exit
fi

# remove FTP_MOUNT_DIR directory
rmdir $FTP_MOUNT_DIR
