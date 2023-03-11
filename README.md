# Let's Encrypt Certificate Renew via FTP

This bash script calls the Let's Encrypt [certbot](https://certbot.eff.org) to generate a new certificate (with private key) and automatically uploads the ACME challenges to a remote server via FTP.
This is especially useful if you have a web hoster that does not support Let's Encrypt.
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
DOMAINS=example.com,www.example.com
FTPSERVER=ftp.example.com
FTPPORT=21
FTPPATH=/ # Path directly to the final acme-challenge dir (always end with /)
FTPUSER=username
FTPPWD=password
```

The path must be the path to the final acme-challenge directory. For example ```/var/www/htdocs/.well-known/acme-challenge/```

## Generate new certificate
1. Run ```./generate.sh example.config --dry-run``` to generate the first certificate (without uploading to the server).
2. If everything is fine, run ```./generate.sh example.config``` to generate the certificate and upload it to the server.
3. Certificate and private key are then stored copied into ```./certificates/``` (with user rights).

### Example output

```
sudo ./generate.sh example.config
Do you want to run the following command (y/N)?

certbot certonly --manual --preferred-challenges http --agree-tos --manual-public-ip-logging-ok -m webmaster@example.com --manual-auth-hook /home/user/git/le-ftp-renew/hook-auth.sh --manual-cleanup-hook /home/user/git/le-ftp-renew/hook-cleanup.sh --deploy-hook /home/user/git/le-ftp-renew/hook-deploy.sh -d example.com,www.example.comy

Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for example.com and www.example.com

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/example.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/example.com/privkey.pem
This certificate expires on 2023-06-09.
These files will be updated when the certificate renews.
Certbot has set up a scheduled task to automatically renew this certificate in the background.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

## Files
- **generate.sh**: Main script
- **example.config**: Example configuration file
- **hook-auth.sh**: Certbot hook for authentication (mounts remote FTP server and writes challenge files)
- **hook-cleanup.sh**: Removes challenge files from FTP server
- **hook-unmount.sh**: Unmounts FTP server
- **hook-deploy.sh**: Copies certificates to ```./certificates/``` and gives 777 permissions
