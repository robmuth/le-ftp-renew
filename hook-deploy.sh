#!/bin/bash

# get directory of script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FTP_MOUNT_DIR="$DIR/remote_ftp"

# check if root
if [ "$EUID" -ne 0 ]
  then echo "Error: Please run as root."
  exit
fi

# Unmount FTP_MOUNT_DIR
fusermount -u $FTP_MOUNT_DIR

# check if FTP_MOUNT_DIR directory is empty
if [ "$(ls -A $FTP_MOUNT_DIR)" ]
  then echo "Error: $FTP_MOUNT_DIR is not empty."
  exit
fi

# path to certificate
CERT="$RENEWED_LINEAGE/fullchain.pem"
PRIV="$RENEWED_LINEAGE/privkey.pem"

# get name of last directory of $CERT
DOMAIN="$(dirname $CERT | xargs basename)"

# move files to certificates
OUT="$DIR/certificates/"

# check if directory exists and create it if not
if [ ! -d "$OUT" ]
  then
    mkdir $OUT
fi

cp "$CERT" "$OUT/$DOMAIN-certificate.pem"
cp "$PRIV" "$OUT/$DOMAIN-privkey.pem"

# change owner of all files to $SUDO_USER recursively
chown -R $SUDO_USER:$SUDO_USER $OUT

# echo new file paths
echo "New certificate: $OUT/$DOMAIN-certificate.pem"
echo "New private key: $OUT/$DOMAIN-privkey.pem"