#!/bin/bash

fun=( '/' '──' '\' '|' )
i=0
index=0
while :
do
		printf " %c \r" ${fun[i]}
		let index++
		let i=index%4
		sleep 0.5
        if [[ $index -eq 4 ]];then
            index=0
        fi
done
printf "\n"
