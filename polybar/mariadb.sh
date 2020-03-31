#!/bin/bash

icon_enabled="  mariadb"
status=`systemctl is-active mariadb.service`

if [[ $status == "active" ]]
then
    echo "$icon_enabled"
else
	echo ""
fi
