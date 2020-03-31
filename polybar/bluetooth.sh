#!/bin/bash

icon_enabled=" bluetooth"
status=`systemctl is-active bluetooth.service`

if [[ $status == "active" ]]
then
    echo "$icon_enabled"
else
	echo ""
fi
