#! /bin/bash

conf="/etc/gdm/Init/Default"
modeline=`cvt $1 $2 | grep Modeline | sed "s/Modeline //"`

if [[ ! $? -eq 0 ]]; then
	echo $"Usage: $0 x y" 1>&2
	exit 1
fi

mode=`echo $modeline | awk '{print $1}'`
output=`xrandr | grep -E "\<connected\>" | awk '{print $1}'`
arg1="xrandr --newmode $modeline\n"
arg2="xrandr --addmode $output $mode\n"
arg3="xrandr --output $output --mode $mode\n"

grep "$mode" "$conf" > /dev/null
if [[ $? -eq 0 ]]; then
	echo $"Alread configured." 1>&2
	exit 2
fi
sudo sed -i "/OLD_IFS=\$IFS/a`echo $arg1$arg2$arg3`" $conf

