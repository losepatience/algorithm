#! /bin/sh

topdir=`pwd`
prefix=$topdir/mtd-utils

# export compile envoriment
CROSS="arm-none-linux-gnueabi-"
CC="${CROSS}gcc"
export CC CROSS

prepare()
{
  mkdir -p $prefix

  if [ ! -d lzo-2.08 ]; then
    if [ ! -f lzo-2.08.tar.gz ]; then
      wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.08.tar.gz
    fi
    tar zxf lzo-2.08.tar.gz
  fi

  if [ ! -d zlib-1.2.8 ]; then
    if [ ! -f zlib-1.2.8.tar.gz ]; then
      wget http://zlib.net/zlib-1.2.8.tar.gz
    fi
    tar zxf zlib-1.2.8.tar.gz
  fi

  if [ ! -d e2fsprogs-1.42.8 ]; then
    if [ ! -f e2fsprogs-1.42.8.tar.bz2 ]; then
      wget http://mirrors.oss.org.cn/linux_kernel/people/tytso/e2fsprogs/v1.42.8/e2fsprogs-1.42.8.tar.bz2
    fi
    tar jxf e2fsprogs-1.42.8.tar.bz2
  fi

  if [ ! -d mtd-utils-1.5.1.tar.bz2 ]; then
    if [ ! -f mtd-utils-1.5.1.tar.bz2 ]; then
      wget ftp://ftp.infradead.org/pub/mtd-utils/mtd-utils-1.5.1.tar.bz2
    fi
    tar jxf mtd-utils-1.5.1.tar.bz2
  fi
}

install()
{
  #echo -e "\n\n\t\tBuildiing zlib\n"
  #cd $topdir/zlib-1.2.8
  #./configure --prefix=$prefix
  #make && make install

  #echo -e "\n\n\t\tBuildiing lzo\n"
  #cd $topdir/lzo-2.08
  #./configure --host=arm-linux --prefix=$prefix
  #make && make install

  #echo -e "\n\n\t\tBuildiing e2fsprogs\n"
  #cd $topdir/e2fsprogs-1.42.8
  #./configure --host=arm-linux --enable-elf-shlibs --prefix=$prefix
  #make && make install

  echo -e "\n\n\t\tBuildiing mtd-utils\n"
  mkdir -p $prefix/include/uuid
  cp -f $topdir/e2fsprogs-1.42.8/lib/uuid/uuid.h $prefix/include/uuid
  cd $topdir/mtd-utils-1.5.1
  CFLAGS="$CFLAGS -I$prefix/include -L$prefix/lib"
  CPPFLAGS="$CFLAGS -I$prefix/include -L$prefix/lib"
  DESTDIR=$prefix/sbin
  export CFLAGS CPPFLAGS DESTDIR
  sed -i "s/^PREFIX/#PREFIX/" common.mk

  make WITHOUT_XATTR=1 PREFIX=$prefix
  make install WITHOUT_XATTR=1
}

case "$1" in
  prepare) prepare ;;
  install) install ;;
  uninstall) uninstall ;;
  *) echo $"Usage: $0 {prepare|install}" 1>&2 ;;
esac
