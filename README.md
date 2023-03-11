# Let's Encrypt Certificate Renew via FTP

This script calls the Let's Encrypt [certbot](https://certbot.eff.org) to generate a new LE certificate and automatically uploads the challenges to a remote server via FTP.
The certificate and private key are copied to ```./certificates/``` so you can manually upload them to your web hoster.

## Installation dependencies:
1. **certbot**: See install instructions with snap [here](https://certbot.eff.org/instructions)
2. **curlftpfs**:

```
sudo apt-get install curlftpfs
modprobe fuse
```

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

## Generate New Certificate
1. Run ```./generate.sh example.config --dry-run``` to generate the first certificate (without uploading to the server).
2. If everything is fine, run ```./generate.sh example.config``` to generate the certificate and upload it to the server.
3. Certificates and private keys are then stored in ```./certificates/```

## Files
- **generate.sh**: Main script
- **example.config**: Example configuration file
- **hook-auth.sh**: Certbot hook for authentication (mounts remote FTP server and writes challenge files)
- **hook-cleanup.sh**: Removes challenge files from FTP server
- **hook-unmount.sh**: Unmounts FTP server
- **hook-deploy.sh**: Copies certificates to ```./certificates/``` and gives 777 permissions
