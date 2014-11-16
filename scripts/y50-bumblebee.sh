#! /bin/bash

# install mouse driver because of an error(Failed to load module "mouse")
sudo yum -y install xorg-x11-drv-mouse

# install keyboard driver because of an error(Failed to load module "kbd")
sudo yum -y install xorg-x11-drv-keyboard

#sudo reboot

# you must disable Security Boot in Bios firstly or
# disabled verifications of the bootloader Shim by
# sudo mokutil --disable-validation 
# sudo reboot

sudo yum install -y libbsd-devel libbsd glibc-devel libX11-devel \
	help2man autoconf git tar glib2 glib2-devel kernel-devel \
	kernel-headers automake gcc gtk2-devel

sudo yum install -y VirtualGL

sudo yum -y --nogpgcheck install http://install.linux.ncsu.edu/pub/\
yum/itecs/public/bumblebee/fedora20/noarch/\
bumblebee-release-1.1-1.noarch.rpm

sudo yum -y install bbswitch bumblebee

sudo yum -y --nogpgcheck install http://install.linux.ncsu.edu/pub/yum/itecs\
/public/bumblebee-nonfree/fedora20/noarch/\
bumblebee-nonfree-release-1.1-1.noarch.rpm

sudo yum install -y glibc-devel
sudo yum install -y bumblebee-nvidia
