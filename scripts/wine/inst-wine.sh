#! /bin/bash

install ()
{
	sudo yum install alsa-lib-devel.i686 alsa-lib-devel \
		audiofile-devel.i686 audiofile-devel \
		alsa-plugins-pulseaudio.i686 cups-devel.i686 cups-devel \
		dbus-devel.i686 dbus-devel fontconfig-devel.i686 \
		fontconfig-devel freetype.i686 freetype-devel.i686 \
		freetype-devel giflib-devel.i686 giflib-devel lcms-devel.i686 \
		lcms-devel libICE-devel.i686 libICE-devel \
		libjpeg-turbo-devel.i686 libjpeg-turbo-devel libpng-devel.i686 \
		libpng-devel libSM-devel.i686 libSM-devel libusb-devel.i686 \
		libusb-devel libX11-devel.i686 libX11-devel libXau-devel.i686 \
		libXau-devel libXcomposite-devel.i686 libXcomposite-devel \
		libXcursor-devel.i686 libXcursor-devel libXext-devel.i686 \
		libXext-devel libXi-devel.i686 libXi-devel \
		libXinerama-devel.i686 libXinerama-devel libxml2-devel.i686 \
		libxml2-devel libXrandr-devel.i686 libXrandr-devel \
		libXrender-devel.i686 libXrender-devel libxslt-devel.i686 \
		libxslt-devel libXt-devel.i686 libXt-devel libXv-devel.i686 \
		libXv-devel libXxf86vm-devel.i686 libXxf86vm-devel \
		mesa-libGL-devel.i686 mesa-libGL-devel mesa-libGLU-devel.i686 \
		mesa-libGLU-devel ncurses-devel.i686 ncurses-devel \
		openldap-devel.i686 openldap-devel openssl-devel.i686 \
		openssl-devel zlib-devel.i686 pkgconfig \
		sane-backends-devel.i686 sane-backends-devel \
		xorg-x11-proto-devel glibc-devel.i686 prelink fontforge flex \
		bison libstdc++-devel.i686 pulseaudio-libs-devel.i686 \
		libgphoto2-devel.i686 openal-soft-devel openal-soft-devel.i686 \
		gsm-devel.i686 samba-winbind libv4l-devel.i686 cups-devel.i686 \
		libtiff-devel.i686 gstreamer-devel.i686 \
		gstreamer-plugins-base-devel.i686 gettext-devel.i686 \
		libmpg123-devel.i686 mesa-dri-drivers.i686 lcms2-devel.i686 -y

	sudo yum install wine cabextract -y

	mkdir -p .tmp && cd .tmp

	if [ ! -f /usr/lib/pkcs11/gnome-keyring-pkcs11.so ]; then
		if [ ! -f gnome-keyring-3.10.1-1.fc20.i686.rpm ]; then
			wget http://dl.fedoraproject.org/pub/fedora/linux/\
releases/`uname -m`/Everything/i386/os/Packages/g/\
gnome-keyring-3.10.1-1.fc20.i686.rpm
		fi

		rpm2cpio gnome-keyring-3.10.1-1.fc20.i686.rpm | cpio -div
		sudo mkdir -p /usr/lib/pkcs11
		sudo cp usr/lib/pkcs11/gnome-keyring-pkcs11.so /usr/lib/pkcs11
	fi

	if [ ! -f /usr/lib/pkcs11/p11-kit-trust.so ]; then
		if [ ! -f p11-kit-trust-0.20.7-1.fc20.i686.rpm ]; then
			wget http://dl.fedoraproject.org/pub/fedora/linux/\
updates/`uname -m`/i386/p11-kit-trust-0.20.7-1.fc20.i686.rpm
		fi

		rpm2cpio p11-kit-trust-0.20.7-1.fc20.i686.rpm | cpio -div
		sudo mkdir -p /usr/lib/pkcs11
		sudo cp usr/lib/pkcs11/p11-kit-trust.so /usr/lib/pkcs11
	fi

	if [ ! -f /usr/bin/winetricks ]; then
		wget http://winetricks.org/winetricks
		chmod +x winetricks
		sudo mv winetricks /usr/bin
	fi
}

#winetricks ie7 riched20  msctf vcrun2005 cjkfonts
#winetricks # install QQ
config ()
{
	grep "export WINEARCH" ~/.bashrc > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo export WINEARCH=\"win32\" >> ~/.bashrc
	fi

	export WINEARCH="win32"
	winecfg
	winetricks riched20 riched30 ie7 vcrun6 msls31 msxml6 \
		vcrun2005 vcrun2008 winhttp cjkfonts # gdiplus
}

clean ()
{
	rm -fr ~/.wine ~/.local/share/applications/wine
	rm -f ~/.local/share/applications/wine-extension-*
	rm -fr ~/.config/menus/applications-merged
	sed -i "/wine-extension/d" ~/.local/share/applications/mimeinfo.cache
	sed -i "/wine/d" ~/.local/share/applications/mimeapps.list
	rm -f ~/.local/share/mime/packages/x-wine-extension-*
	update-mime-database ~/.local/share/mime
}

cn()
{
	fontsize=13
	winedir=~/.wine
	windir=$winedir/drive_c/windows
	cp simsun.ttc $windir/Fonts
	sed -i 's/\("LogPixels"=dword:\).*/\100000070/' $winedir/system.reg
	regedit cn.reg
	grep "menufontsize=$fontsize" $windir/win.ini > /dev/null 2>&1
	if [[ $? -eq 0 ]]; then
		return
	fi
cat >> $windir/win.ini << EOF
[Desktop]
menufontsize=$fontsize
messagefontsize=$fontsize
statusfontsize=$fontsize
IconTitleSize=$fontsize
EOF
}


usage ()
{
	echo $"Usage: $0 {install|clean|config|cn}" 1>&2
}

case "$1" in
	install) install ;;
	config) config ;;
	clean) clean ;;
	cn) cn;;
	*) usage ;;
esac

