#!/bin/bash
#turn off laptop display and turn on VGA1
control=$((0))
while :
do
	status0=$(</sys/class/drm/card0-HDMI-A-1/status)
	status1=$(</sys/class/drm/card0-VGA-1/status)
	if [ $status0 = "connected" ] && [ $status1 = "connected" ]
	then
		if ((control != 1))
		then
			xrandr --output HDMI1 --mode 1920x1080 --right-of LVDS1
			xrandr --output LVDS1 --off
			xrandr --output VGA1 --mode 1920x1080  --left-of HDMI1
			control=$((1))
		fi
	else
		xrandr --output LVDS1 --mode 1366x768
		control=$((0))
		if [ $status0 = "connected" ]
		then
			xrandr --output HDMI1 --mode 1920x1080
			xrandr --output HDMI1 --right-of LVDS1
		fi
		if [ $status1 = "connected" ]
		then
			xrandr --output VGA1 --mode 1920x1080
			xrandr --output VGA1 --left-of LVDS1
		fi
	fi
	sleep 10
done

