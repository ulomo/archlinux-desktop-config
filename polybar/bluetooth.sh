#!/bin/bash

icon_enabled=""
status=`systemctl is-active bluetooth.service`

if [[ $status == "active" ]]
then
    sound=`amixer sget Master | tail -n1 | awk '{print $5}'`
    for dev in `bluetoothctl devices | awk '{print $2}'`
    do
        conn=`bluetoothctl info $dev | grep Connect | awk '{print $2}'`
        if [[ $conn == "yes" ]];then
            dev_name=`bluetoothctl info | grep Name | cut -c 8-`
            echo "$icon_enabled $dev_name $sound"
        else
            echo "$icon_enabled"
        fi
    done
fi
