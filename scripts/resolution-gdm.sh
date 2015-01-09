#! /bin/sh

kernel=`uname -r`
grubdir=`sudo find /boot -name "grub.cfg" | xargs dirname`
grubcfg=$grubdir/grub.cfg

conf="/etc/gdm/Init/Default"
modeline=`cvt 1920 1080 | grep Modeline | sed "s/Modeline //"`
mode=`echo $modeline | awk '{print $1}'`
output=`xrandr -q | grep -E "\<connected\>" | awk '{print $1}'`
arg1="xrandr --newmode $modeline\n"
arg2="xrandr --addmode $output $mode\n"
arg3="xrandr --output $output --mode $mode"

sudo grub2-mkfont /usr/share/fonts/dejavu/DejaVuSansMono.ttf \
                  --size=16 --output=$grubdir/fonts/DejaVuSansMono.pf2
sudo grep "DejaVuSansMono.pf2" /etc/sysconfig/grub > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  echo "GRUB_FONT=$grubdir/fonts/DejaVuSansMono.pf2" \
       | sudo tee -a /etc/sysconfig/grub
fi
sudo grub2-mkconfig -o $grubdir/grub.cfg

sudo grep "$kernel" $grubcfg | grep "video=eDP-1:1280x720" > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  sudo sed -i "/linuxefi.*$kernel/{s/$/ video=eDP-1:1280x720/}" $grubcfg
fi


grep "$output" "$conf" > /dev/null 2>&1
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


