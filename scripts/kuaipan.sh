#! /bin/sh

pkg="kuaipan4uk_1404_2.0.0.3_amd64.deb"

kuaipan_prepare()
{
  sudo yum install -y libqxt boost-iostreams
  wget https://launchpadlibrarian.net/180448424/$pkg
}

kuaipan_install()
{
  mkdir tmp
  cd tmp
  cp ../$pkg .
  ar -x $pkg
  
  tar -xvf data.tar.xz
  
  sudo cp -r usr /
  sudo cp -r opt /
}

kuaipan_clean()
{
  rm -fr /opt/ubuntukylin
  rm -f /usr/share/keyrings/kuaipan-archive-keyring.gpg
  rm -f /usr/share/pixmaps/kuaipan4uk.png
  rm -fr /usr/share/doc/{kuaipan4uk,kuaipan}
  rm -f /usr/share/applications/kuaipan4uk.desktop
  rm -f /usr/bin/{kuaipan4uk_script,kuaipan4uk}
}

case "$1" in
  prep)
        kuaipan_prepare
        ;;
  install)
        kuaipan_install
        ;;
  clean)
        kuaipan_clean
        ;;
  *)
        echo "Usage: $0 {prep|install|clean}"
        exit 1
        ;;
esac

exit
