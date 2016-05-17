#!/bin/sh
# OpenWrt Deep Night Sleeping
# Copyright (C) 2016 @zhangjingye03
# Based on MIT License


# blinking led name, can be found in /sys/class/leds/
LED="tp-link:blue:qss"
# set blinking delay
DELAY_ON=1000
DELAY_OFF=5000
# usb power gpio
USB1_POWER="gpio21"
USB2_POWER="gpio22"

# ifdown all interfaces
wifi down
for i in $(ifconfig | grep "Link encap:" | sed 's/Link.*//')
do
	ifconfig $i down
done

# kill lots of services
killall uhttpd lua dropbear hostapd sftp-server pppd ntpd odhcpd vsftpd dnsmasq ntpd radiusd radvd dhcrelay

# turn off all leds
for file in /sys/class/leds/*/brightness
do
        echo 0 > $file
done

# keep one led breathing
cd /sys/class/leds/$LED
echo timer > trigger
echo $DELAY_ON > delay_on
echo $DELAY_OFF > delay_off

# remove lots of modules
# loop for 10 times to rmmod some high-dependent modules
for j in $(seq 0 10)
do
	for i in $(find /lib/modules | grep ko)
	do
		rmmod $i
	done
done

# stop all the services except crond
for i in $(ls /etc/init.d/ | grep -v cron)
do
	/etc/init.d/$i stop
done
# "umount stop" includes sync and umount all

# shut down usb power
echo 0 > /sys/class/gpio/$USB1_POWER/value
echo 0 > /sys/class/gpio/$USB2_POWER/value

logger Finished. Powersaved.
