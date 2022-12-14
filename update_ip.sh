#!/bin/bash

auth_email=${1}
auth_key=${2}
zone_name=${3}
record_name=${4}
ip=${5}
proxied=${6}

# CREATE FOLDER
mkdir -p $zone_name/$record_name

# DECLARE LOG FILES
ip_file="$zone_name/$record_name/ip"
id_file="$zone_name/$record_name/ids"
log_file="log"



# LOGGER
log() {
    if [ "$1" ]; then
        echo -e "[$(date)] - $1" >> $log_file
    fi
}

# SCRIPT START
if [ -f $ip_file ]; then
    old_ip=$(cat $ip_file)
    if [ "$ip" == "$old_ip" ]; then
        echo "$record_name IP has not changed."
        exit 0
    fi
fi

if [ -f $id_file ] && [ $(wc -l $id_file | cut -d " " -f 1) == 2 ]; then
    zone_identifier=$(head -1 $id_file)
    record_identifier=$(tail -1 $id_file)
else
    zone_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json" | grep -Po '(?<="id":")[^"]*' | head -1 )
    record_identifier=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?name=$record_name" -H "X-Auth-Email: $auth_email" -H "X-Auth-Key: $auth_key" -H "Content-Type: application/json"  | grep -Po '(?<="id": ")[^"]*')
    echo "$zone_identifier" > $id_file
    echo "$record_identifier" >> $id_file
fi

update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" \
  -H "X-Auth-Email: $auth_email" \
  -H "X-Auth-Key: $auth_key" \
  -H "Content-Type: application/json" \
  --data "{\"id\": \"$zone_identifier\", \"type\": \"A\", \"name\": \"$record_name\", \"content\": \"$ip\", \"ttl\": 1, \"proxied\": $proxied}")


if [ "$update" != "${update%success*}" ] || [ "$(echo $update | grep "\"success\": true")" != "" ]; then
  echo "$ip" > $ip_file
  message="$record_name IP changed to: $ip"
  log "$message"
  echo "$message"
  exit
else
  message="$record_name API UPDATE FAILED [IP : $ip]. DUMPING RESULTS:\n$update"
  log "$message"
  echo -e "$message"
  exit 1
fi
