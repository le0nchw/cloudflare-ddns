#!/bin/bash
ip=$(curl -s https://api.ipify.org/) # YOU MAY CHANGE OTHER SERVICES SUPPLIER

auth_email="example@gmail.com" # YOUR CLOUDFLARE ACCOUNT'S EMAIL ADDRESS
auth_key="xxxxx" # FOUND IN CLOUDFLARE ACCOUNT SETTINGS

# usage: ./update_ip.sh  "$auth_email" "$auth_key" zone_name domain_name "$ip" proxy(cdn)
# zone_name - your root domain name
# domain_name - the domain name that you want to update
# ip - fetch ip address from thity-party supplier (ipv4 only)
# proxy(cdn) - apply cloudflare proxy or not (true or false)

# you can update multiple records here

./update_ip.sh "$auth_email" "$auth_key" example.com www.example.com "$ip" false