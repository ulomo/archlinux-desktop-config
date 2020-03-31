#!/bin/bash

# 设置定时任务
time=`date +%M`

if [[ $time == '00' ]];then
    notify-send "it is time to study !"
#    mplayer  http://dict.youdao.com/dictvoice\?audio\="it's time to study" &>/dev/null
    mplayer /home/narcissus/Music/prompt/wechat.mp3 &>/dev/null
elif [[ $time == '45' ]];then
    notify-send "have a rest !"
#    mplayer  http://dict.youdao.com/dictvoice\?audio\="have a rest" &>/dev/null
    mplayer /home/narcissus/Music/prompt/wechat.mp3 &>/dev/null
fi

# # 检测蓝牙
# bluetooth_icon_enabled=" bluetooth"
# bluetooth_status=`systemctl is-active bluetooth.service`
#
# if [[ $bluetooth_status == "active" ]]
# then
#     echo "$bluetooth_icon_enabled"
# else
# 	echo ""
# fi

# # 检测ftpd
# ftp_icon_enabled="  ftp"
# ftp_status=`systemctl is-active ftpd.service`
#
# if [[ $ftp_status == "active" ]]
# then
#     echo "$ftp_icon_enabled"
# else
# 	echo ""
# fi

# # 检测mariadb
# mariadb_icon_enabled="  mariadb"
# mariadb_status=`systemctl is-active mariadb.service`
#
# if [[ $mariadb_status == "active" ]]
# then
#     echo "$mariadb_icon_enabled"
# else
# 	echo ""
# fi

# 检测shadowsocks
ss_icon_enabled="  ss"
ss_status=`ps -fu | grep sslocal | grep -v grep`

if [[ $? == 0 ]]
then
    echo "$ss_icon_enabled"
else
	echo ""
fi

# # 检测sshd
# ssh_icon_enabled="  sshd"
# ssh_status=`systemctl is-active sshd.service`
#
# if [[ $ssh_status == "active" ]]
# then
#     echo "$ssh_icon_enabled"
# else
# 	echo ""
# fi

# 检测docker
docker_icon_enabled=" docker  "
docker_status=`systemctl is-active docker`


if [[ $docker_status == "active" ]]
then
    echo -n "$docker_icon_enabled"
    if sudo docker ps | sed -n '2,$p' &>/dev/null;then
        echo -n "`sudo docker ps | awk '{print "=>[",$NF,"]"}' | sed -n '2,$p' | xargs -n 100`"
    fi
else
	echo ""
fi
