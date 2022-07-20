#!/bin/bash

data=$(playerctl metadata 2> /dev/null)
[ $? -ne 0 ] \
    && echo " " \
    && exit 0

title=$(echo "$data" \
    | grep "xesam:title" \
    | sed 's/^[^:]*:[^ ]*//' \
    | sed 's/^\s*//' \
    | tr -d '\n' \
    | sed 's/^\(.\{25\}\).*/\1.../')
artist=$(echo "$data" \
    | grep "xesam:artist" \
    | sed 's/^[^:]*:[^ ]*//' \
    | sed 's/^\s*//' \
    | tr -d '\n' \
    | sed 's/^\(.\{25\}\).*/\1.../')

echo "$artist: $title"
