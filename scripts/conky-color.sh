#! /bin/bash

install ()
{
	sudo yum install ImageMagick conky -y
	mkdir -p .tmp && cd .tmp
	if [ ! -f conky_colors_by_helmuthdu-d41qrmk.zip ]; then
		wget http://125.39.35.131/files/21220000032B6CD8/www.devia\
ntart.com/download/244793180/conky_colors_by_helmuthdu-d41qrmk.zip
	fi

	rm -fr conky_colors && unzip conky_colors_by_helmuthdu-d41qrmk.zip
	cd conky_colors
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
	net=`sudo ifconfig | grep "^p[0-9]" | awk -F ":" '{print $1}'`
	sed -i "s/eth0/$net/g" ~/.conkycolors/conkyrc
	net=`sudo ifconfig | grep "^wlp" | awk -F ":" '{print $1}'`
	sed -i "s/wlan0/$net/g" ~/.conkycolors/conkyrc

	home=$HOME
	sudo sed -i "s!source=.*!source=$home/Pictures!" \
		/usr/share/conkycolors/bin/conkyPhotoRandom

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



