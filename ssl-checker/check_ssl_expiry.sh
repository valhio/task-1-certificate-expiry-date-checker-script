#!/bin/bash

domains_file="domains.txt"

if [[ ! -f "$domains_file" ]]; then
  echo "Error: File '$domains_file' not found."
  exit 1
fi

while read domain; do
    echo "Checking SSL certificate for $domain ..."
    
	res=$(echo | openssl s_client -servername "$domain" -connect "$domain":443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
    # res=$(openssl s_client -servername "$domain" -connect "$domain":443 < /dev/null 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2) # alternate way
  	
	if [[ -z "$res" ]]; then
    	echo "  ❌ Failed to retrieve certificate for $domain"
 		continue
  	fi

    date_s=$(date -d "${res}" +%s)
    now_s=$(date -d now +%s)
    days_left=$(( (date_s - now_s) / 86400 ))

	if (( days_left < 0 )); then
    	echo "Certificate expired $(( -days_left )) days ago"
 	else
    	echo "Certificate will expire in $days_left days"
  	fi

done < "$domains_file"

# resources used:
# https://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash # reading file line by line
# https://askubuntu.com/questions/1198619/bash-script-to-calculate-remaining-days-to-expire-ssl-certs-in-a-website # date calculations
# https://stackoverflow.com/questions/13509508/check-if-string-is-neither-empty-nor-space-in-shell-script # string empty check
# https://stackoverflow.com/questions/59579505/need-help-to-write-shell-script-to-check-if-file-exist-or-not # file existence check