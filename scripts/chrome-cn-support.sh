#! /bin/bash

packet="google-chrome-stable_current_`uname -m`.rpm"

san=/etc/fonts/conf.d/49-sansserif.conf
default="WenQuanYi Zen Hei"

which google-chrome > /dev/null
if [[ $? -ne 0 ]]; then
	if [[ ! -f $packet ]]; then
		wget https://dl.google.com/linux/direct/$packet
	fi
	sudo yum localinstall -y $packet
fi
chrome=`which google-chrome`

# FIXME
if [ ! -z $1 ]; then
	fc-list | awk -F ':' '{print $2}' | grep "$1" > /dev/null 2>&1
	if [[ ! $? -eq 0 ]]; then
		echo "No font $1 found"
		exit -3
	fi
	font="$1"
else
	font="$default"
fi

grep 'LANG="zh_CN.UTF-8"' $chrome > /dev/null 2>&1
if [[ ! $? -eq 0 ]]; then
	sudo sed -i '/export CHROME_WRAPPER=/aLANG="zh_CN.UTF-8"' $chrome
fi

sed "/<edit/!b;n;c\\\t\t\t<string>$font</string>" $san > tmp
sudo mv tmp $san

