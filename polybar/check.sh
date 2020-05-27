#!/bin/bash

free=`free -m | awk '{print $NF}' | sed -n '2p'`
if [[ $free -le 2000 ]];then
    notify-send -u low "notice! memory less than 1Gb"
    if [[ $free -le 1000 ]];then
        notify-send -u critical "hurry! memory less than 1Gb"
    fi
fi
