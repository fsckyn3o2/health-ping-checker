#!/bin/bash

function health-checker-shell-pinger() {
  pinger=$1
  domain=$2
  environment=$3
  baseUrl=$4
  extrainfo=$5
  
  
  calcDomain="${environment}.${domain}"
  calcUrl="https://${calcDomain}${baseUrl}"
  
  if [ "$pinger" == "ping" ]
  then
    pingedOutput=`ping -n 1 ${calcDomain} | grep -Eo '\[[0-9.]{4,}\]'`
    pingedRes="$?"
  
    if [ "$pingedRes" == "0" ]
    then
        echo -e "${environment}\t${pingedOutput}\t${calcDomain}\t${calcUrl}\t${extrainfo}"
        exit 0
    else
        echo -e "FAILED"
        exit 1
    fi;
  fi;
  
  if [ "$pinger" == "curl-200" ]
  then
      pingedOutput=`curl -o /dev/null --silent --head --write-out '${environment}\t%{remote_ip} - %{http_code}\t${calcDomain}\t${calcUrl}\t${extrainfo}' "${calcUrl}"`
      pingedRes=`curl -o /dev/null --silent --head --write-out '%{http_code}' "${calcUrl}"`
      
      if [ "$pingedRes" == "200" ]
      then
        echo -e ${pingedOutput}
        exit 0
      else
        echo -e "FAILED"
        exit 1
      fi;
  fi;
}
