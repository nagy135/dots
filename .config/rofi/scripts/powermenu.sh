#!/bin/bash

if [ -z "$@" ]; then
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
    echo -en "Hibernate\0icon\x1fsystem-hibernate\n"
    echo -en "Exit\0icon\x1fsystem-log-out\n"
    echo -en "Suspend\0icon\x1fsystem-suspend\n"
    echo -en "Reboot\0icon\x1fsystem-restart\n"
else
    if [ "$1" = "Shutdown" ]; then
        loginctl poweroff
    elif [ "$1" = "Exit" ]; then
        bspc quit
    elif [ "$1" = "Reboot" ]; then
        loginctl reboot
    elif [ "$1" = "Suspend" ]; then
        loginctl suspend
    elif [ "$1" = "Hibernate" ]; then
        loginctl hibernate
    fi
fi
