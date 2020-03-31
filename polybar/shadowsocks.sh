#!/bin/bash

icon_enabled="  ss"
status=`ps -fu | grep sslocal | grep -v grep`

if [[ $? == 0 ]]
then
    echo "$icon_enabled"
else
	echo ""
fi
