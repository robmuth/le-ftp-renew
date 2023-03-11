#!/bin/bash

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