#!/bin/bash

# get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FTP_MOUNT_DIR="$DIR/remote_ftp"

# check if root
if [ "$EUID" -ne 0 ]
  then echo "Error: Please run as root."
  exit
fi

# Check if FTP_MOUNT_DIR is mounted and unmount it
if [ "$(mount | grep $FTP_MOUNT_DIR)" ]
  then fusermount -u $FTP_MOUNT_DIR
fi

# check if FTP_MOUNT_DIR directory is empty
if [ "$(ls -A $FTP_MOUNT_DIR)" ]
  then echo "Error: $FTP_MOUNT_DIR is not empty."
  exit
fi

# remove FTP_MOUNT_DIR directory
rmdir $FTP_MOUNT_DIR
