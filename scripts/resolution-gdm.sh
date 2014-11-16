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
arg3="xrandr --output $output --mode $mode"

grep "$mode" "$conf" > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
	sudo sed -i "/OLD_IFS=\$IFS/a`echo $arg1$arg2$arg3`" $conf
fi

if [ -f ~/.config/monitors.xml ]; then
	# copy it over to GDM’s configuration so that GDM will display at
	# the correct resolution
	sudo cp ~/.config/monitors.xml /var/lib/gdm/.config

	sudo mkdir -p /etc/skel/.config

	# for new accounts, they will automatically be set up with the
	# monitors config
	sudo cp ~/.config/monitors.xml /etc/skel/.config/
fi

