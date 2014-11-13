#! /bin/bash

PACKET=conky_colors_by_helmuthdu-d41qrmk.zip

install ()
{
	sudo yum install ImageMagick conky -y
	mkdir -p .tmp && cd .tmp && rm -fr conky_colors
	if [ ! -f conky_colors_by_helmuthdu-d41qrmk.zip ]; then
		wget http://fc00.deviantart.net/fs71/f/2013/290/5/b/$PACKET
	fi

	unzip $PACKET && cd conky_colors
	make
	sudo make install
	conky-colors --theme=custom --default-color=black --color0=cyan \
		--color1=green --color2=orange --color3=red --fedora \
		--cpu=2 --updates --proc=3 --clock=modern --calendar \
		--hd=default --photord --network --unit=C --side=right \
		--bbcweather=1586 --weather=CHXX0100 
	rm -fr .tmp
}

config ()
{
	sed -i "s/aptitude/yum/g" ~/.conkycolors/conkyrc
	sed -i "s/(null)/\/usr\/share\/conkycolors/g" ~/.conkycolors/conkyrc
	eth=`sudo ifconfig | grep "^p[0-9]" | head -1 | awk -F ":" '{print $1}'`
	if [ -n "$eth" ]; then
		sed -i "s/eth0/`echo $eth`/g" ~/.conkycolors/conkyrc
	fi
	wlan=`sudo ifconfig | grep "^wlp" | head -1 | awk -F ":" '{print $1}'`
	if [ -n "$wlan" ]; then
		sed -i "s/wlan0/$wlan/g" ~/.conkycolors/conkyrc
	fi

	sed -i "s!source=.*!source=$HOME/Pictures!" \
		$HOME/.conkycolors/bin/conkyPhotoRandom

	sed -i "/# \- HD \- #/,/# \- NETWORK \- #/d" ~/.conkycolors/conkyrc
}

usage ()
{
	echo $"Usage: $0 {install|config}" 1>&2
}

case "$1" in
	install) install ;;
	config) config ;;
	*) usage ;;
esac



