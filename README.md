# LE FTP Renew

This script calls certbot to generate a new LE certificate and uploads the challanges automatically with FTP.

## Installation
1. Make sure that [certbot] is installaed
2. Run ```01_init.sh install``` to install CurlFtpFS if not already installed.

## Configuration
Make a configuration file with the domains (comma separated) and their FTP credentials. Example:

```
DOMAINS=example.com,example.de
FTPSERVER=ftp.example.com
FTPPORT=21
FTPPATH=/ # Path directly to the final acme-challenge dir (always end with /)
FTPUSER=username
FTPPWD=password
```

The path must be the path to the final acme-challenge directory. For example ```/var/www/htdocs/.well-known/acme-challenge/```

## Generate First Certificate
1. Run ```./02_generate.sh example.config --dry-run``` to generate the first certificate (without uploading to the server).
2. If everything is fine, run ```./02_generate.sh example.config``` to generate the certificate and upload it to the server.


[certbot](https://certbot.eff.org)