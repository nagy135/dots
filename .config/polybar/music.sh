#!/bin/sh

mpc idleloop options player | while read line; do
    /home/infiniter/.config/polybar/musicdata
done
