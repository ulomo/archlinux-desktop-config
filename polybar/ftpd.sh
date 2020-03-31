#!/bin/bash

icon_enabled="  ftp"
status=`systemctl is-active ftpd.service`

if [[ $status == "active" ]]
then
    echo "$icon_enabled"
else
	echo ""
fi
