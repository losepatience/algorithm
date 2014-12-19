#! /bin/sh

fedup_prepare()
{
  sudo yum update -y
  touch .prepare
  sudo sync 
  sudo reboot
}

fedup_install()
{
  if [[ ! -f .prepare ]]; then
    fedup_prepare
  fi
  rm -f .prepare
  sudo yum install -y fedup
  sudo fedup --network 21 --product=server
}

fedup_clean()
{
  sudo rpm --rebuilddb
  sudo yum distro-sync --setopt=deltarpm=0
}


case "$1" in
  prepare)
        fedup_prepare
        ;;
  install)
        fedup_install
        ;;
  clean)
	fedup_clean
        ;;
  *)
        echo "Usage: $0 {prepare|install|clean}"
        exit 1
        ;;
esac
