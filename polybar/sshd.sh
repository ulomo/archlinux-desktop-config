#!/bin/bash

icon_enabled="  sshd"
status=`systemctl is-active sshd.service`

if [[ $status == "active" ]]
then
    echo "$icon_enabled"
else
	echo ""
fi
