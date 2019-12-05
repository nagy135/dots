#!/bin/bash

i3status | while :
do
    read line
    bright=`xbacklight -get`
    echo "$bright | $line" || exit 1
done
