# Cloudflare DDNS IP Updater

This script is used to update your DNS records using the Cloudflare API.


## Installation

```
git clone https://github.com/le0nchw/cloudflare-ddns.git
```

## Usage
1. config & add record(s) on `main.sh`
2. add execute permission for `main.sh` and `update_ip.sh`
```
sudo chmod +x main.sh update_ip.sh
```
3. config your crontab to update automatically(crontab -e)
```
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  *  {Location of the main.sh}

```