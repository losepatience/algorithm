#! /bin/bash
# --- set up fedora 20 

user=`whoami`

sudo echo
if [[ $? -ne 0 ]]; then
	echo -e "$user\tALL=(ALL)\tALL" | sudo -u root   tee -a /etc/sudoers
fi

#  Install rpmfusion repos
sudo yum localinstall -y --nogpgcheck http://download1.rpmfusion.org/\
free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

sudo yum localinstall -y --nogpgcheck http://download1.rpmfusion.org/\
nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

yum makecache
sudo yum install yum-fastestmirror yum-presto -y
sudo yum update -y


 #  Install gnome shell themes
sudo yum install gnome-shell-theme-* gnome-tweak-tool \
	gnome-shell-extension-user-theme.noarch -y

sudo yum install elementary-icon-theme echo-icon-theme \
	faience-icon-theme \
	tango-icon-theme tango-icon-theme-extras -y


#  Install media players
sudo yum install audacious audacious-plugins-freeworld vlc -y

sudo yum install http://linuxdownload.adobe.com/adobe-release/\
adobe-release-x86_64-1.0-1.noarch.rpm -y
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
sudo yum install flash-plugin -y

#  Install develop tools
sudo yum install unrar git git-gui gitk gnupg gnupg2 flex bison gperf gcc \
	gcc-c++ zip curl zlib-devel wget mtd-utils mtd-utils-ubi \
	fakeroot fakeroot-libs gawk subversion unixODBC util-linux \
	SDL-devel esound-devel esound-libs wxGTK-devel ncurses-devel \
	readline-devel libzip-devel xorg-x11-proto-devel libbsd-devel \
	libbsd glibc-devel libX11-devel help2man autoconf  glib2 \
	glib2-devel kernel-devel kernel-headers automake gtk2-devel -y
sudo yum install texinfo texinfo-tex texi2html -y

#  Install fav
sudo yum install vim vim-X11 cscope ctags cherrytree nautilus-open-terminal -y
sudo yum install p7zip p7zip-plugins xclip yumex -y
sudo yum install thunderbird -y


#  Install fcitx 
sudo yum remove ibus -y

# Gsettings should be run by you
gsettings set org.gnome.settings-daemon.plugins.keyboard active false
sudo yum install fcitx fcitx-table fcitx-table-chinese \
	fcitx-pinyin fcitx-configtool -y

