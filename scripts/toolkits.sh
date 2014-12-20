#! /bin/sh

# -------- toolkits for fedora 21 -------- #
# kdiff: diff
# iotop: monitor operations on hardisk
# recordmydesktop: alternative to istanbul(ctrl+alt+s to stop)
# okular: pdf reader
# bleachbit: delete unnecessary files to free up your disk
# shutter: screen capture
# cairo-dock: dock
# gthumb: image viewer
# dia: flow chart(better than and an alternative to calligra-flow)
# variaty: wallpaper changer(best, wallpapoz is an simple alternative)
# ---------------------------------------- #
sudo yum install kdiff3 iotop gtk-recordmydesktop bleachbit shutter \
                 cairo-dock gthumb dia -y

which fedy > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  sudo curl http://satya164.github.io/fedy/fedy-installer -o fedy-installer
  sudo chmod +x fedy-installer && sudo ./fedy-installer
fi

# users with /sbin/nologin can connect through ssh or ftp,
# users with /bin/false are completely locked out from the system
# -M: not to create a home directory
# -N: not to create a group having the user's name
# gpasswd -d user group: delete user from group
which variety > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
  exit 0
fi

id mockbuild > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
  sudo useradd -M -r -s /bin/false -c "mock build" mockbuild
fi

rpmdev-setuptree

sudo yum install python-devel python-setuptools python-distutils-extra \
    python-beautifulsoup4 python-configobj python-imaging-devel \
    pyexiv2 intltool rpm-build -y

wget -c http://sourceforge.net/projects/postinstaller/files/fedora/releases/21/SRPM/variety-0.4.20-1.fc21.src.rpm

rpmbuild --rebuild variety-0.4.20-1.fc21.src.rpm
rm -f variety-0.4.20-1.fc21.src.rpm
sudo yum localinstall -y $HOME/rpmbuild/RPMS/noarch/variety-0.4.20-1.fc21.noarch.rpm

# gnome-shell extensions:
#   Applications menu
#   Places status indicator
#   TopIcons
#   Dash to dock
#   Alternatetab

# Font 
sudo yum install -y google-droid-sans-fonts
# Windows Titles(窗口标题字体):	DroidSans
# Interface(默认字体):	DroidSans
# Documents(文档字体):	Sans
# Monospace(等宽字体):	Monospace
