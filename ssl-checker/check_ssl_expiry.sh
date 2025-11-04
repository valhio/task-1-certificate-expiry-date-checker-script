#!/bin/bash

while read domain; do
    echo "Checking SSL certificate for $domain ..."
    res=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
    # res=$(openssl s_client -servername "$domain" -connect "$domain":443 < /dev/null 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2) # alternate way
    date_s=$(date -d "${res}" +%s)
    now_s=$(date -d now +%s)
    days_left=$(( (date_s - now_s) / 86400 ))
    echo "$domain certificate will expire in $days_left days"

done <domains.txt

# resources used:
# https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash
# https://askubuntu.com/questions/1198619/bash-script-to-calculate-remaining-days-to-expire-ssl-certs-in-a-website
