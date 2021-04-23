#!/bin/bash

PATH="/home/infiniter/.config/composer/vendor/bin:$PATH"

dunst &
battery_notify &
xautolock -time 60 -locker 'loginctl suspend' -notify 60 -notifier "notify-send -u critical 'Inactivity' 'Suspend in 1 minute!'" &
unclutter -idle 3 &
xset r rate 200 35
xmodmap -e 'clear Lock' #ensures you're not stuck in CAPS on mode
setxkbmap -option caps:escape
feh --bg-fill ~/Pictures/current_wallpaper
xbacklight -set 50
xsetroot -cursor_name left_ptr
rmmod pcspkr &
bash -c "mpd ~/.config/mpd/mpd.conf"
synclient VertScrollDelta=-111
bash -c "transmission-daemon"
bash -c "brightness_notification -init" # initial brightness setting
bash -c "layout_toggler us" # just to create file in /tmp with default value "us"
bash -c "redshift_control -init" # initial redshift setting
bash -c "volume_change -init" # initial volume setting
