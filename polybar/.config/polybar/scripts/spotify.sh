#!/bin/bash

data=$(playerctl metadata 2> /dev/null)
[ $? -ne 0 ] \
    && echo " " \
    && exit 0

echo "$data" \
    | grep "xesam:title\|xesam:artist" \
    | sort \
    | tail -2 \
    | sed 's/[a-z]* xesam:title\s*/: / ; s/[a-z]* xesam:artist\s*//' \
    | tr -d '\n' \
    | sed 's/^\(.\{45\}\).*/\1.../' \
    | sed 's/^\s*://'
