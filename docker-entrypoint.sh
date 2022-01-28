#!/bin/bash

# ARI add origins
echo "allowed_origins=${ARI_ALLOWED_ORIGINS}" >> /etc/asterisk/ari.conf

# ARI generate user
if [ -n "${ARI_USER}" ] && [ -n "${ARI_PASSWORD}" ]; then
   echo "ARI credentials provided."
   echo -e "\n[${ARI_USER}]\ntype = user\nread_only = no\npassword = ${ARI_PASSWORD}" >> /etc/asterisk/ari.conf
else
   echo "ARI credentials not provided"
fi

asterisk -U asterisk -G asterisk -f