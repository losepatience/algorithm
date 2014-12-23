#! /bin/sh

# -------- toolkits for fedora 21 -------- #
# kdiff: diff
# iotop: monitor operations on hardisk
# lshw-gui: pc info
# recordmydesktop: alternative to istanbul(ctrl+alt+s to stop)
# okular: pdf reader
# bleachbit: delete unnecessary files to free up your disk
# shutter: screen capture
# cairo-dock: dock
# gthumb: image viewer
# dia: flow chart(better than and an alternative to calligra-flow)
# variaty: wallpaper changer(best, wallpapoz is an simple alternative)
# ---------------------------------------- #
sudo yum install kdiff3 iotop lshw-gui gtk-recordmydesktop bleachbit \
  shutter cairo-dock gthumb dia -y

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

# Windows Titles(窗口标题字体):	DroidSans
# Interface(默认字体):	DroidSans
# Documents(文档字体):	Sans
# Monospace(等宽字体):	Monospace

# Alternative to Dropbox
#   SpiderOak

# ia32
sudo yum install glibc.i686 arts.i686 audiofile.i686 bzip2-libs.i686 \
  cairo.i686 cyrus-sasl-lib.i686 dbus-libs.i686 \
  esound-libs.i686 fltk.i686 freeglut.i686 gtk2.i686 \
  imlib.i686 lcms-libs.i686 lesstif.i686 libacl.i686 libao.i686 \
  libattr.i686 libcap.i686 libdrm.i686 libexif.i686 libgnomecanvas.i686 \
  libICE.i686 libieee1284.i686 libsigc++20.i686 libSM.i686 \
  libtool-ltdl.i686 libusb.i686 libwmf.i686 libwmf-lite.i686 \
  libX11.i686 libXau.i686 libXaw.i686 libXcomposite.i686 libXdamage.i686 \
  libXdmcp.i686 libXext.i686 libXfixes.i686 libxkbfile.i686 libxml2.i686 \
  libXmu.i686 libXp.i686 libXpm.i686 libXScrnSaver.i686 libxslt.i686 \
  libXt.i686 libXtst.i686 libXv.i686 libXxf86vm.i686 lzo.i686 \
  mesa-libGL.i686 mesa-libGLU.i686 nas-libs.i686 \
  cdk.i686 openldap.i686 pam.i686 popt.i686 pulseaudio-libs.i686 \
  sane-backends-libs.i686 SDL.i686 \
  svgalib.i686 unixODBC.i686 zlib.i686 compat-expat1.i686 \
  compat-libstdc++-33.i686 openal-soft.i686 \
  redhat-lsb.i686 alsa-plugins-pulseaudio.i686 alsa-plugins-oss.i686 \
  alsa-lib.i686 nspluginwrapper.i686 libXv.i686 libXScrnSaver.i686 \
  qt.i686 qt-x11.i686 pulseaudio-libs.i686 pulseaudio-libs-glib2.i686 \
  alsa-plugins-pulseaudio.i686 -y
