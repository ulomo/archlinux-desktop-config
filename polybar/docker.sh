#!/bin/bash

icon_enabled=" docker  "
status=`systemctl is-active docker`


if [[ $status == "active" ]]
then
    echo -n "$icon_enabled"
    if sudo docker ps | sed -n '2,$p' &>/dev/null;then
        echo -n "`sudo docker ps | awk '{print "=>[",$NF,"]"}' | sed -n '2,$p' | xargs -n 100`"
    fi
else
	echo ""
fi
