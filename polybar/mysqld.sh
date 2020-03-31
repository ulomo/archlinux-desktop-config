#!/bin/bash

icon_enabled="  mysql"
status=`systemctl is-active mysqld.service`

if [[ $status == "active" ]]
then
    echo "$icon_enabled"
else
	echo ""
fi
