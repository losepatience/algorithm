#! /bin/bash

topdir=`pwd`
prefix=$topdir/target
build=$topdir/build

host="arm-fsl-linux-gnueabi"
target=$host


# export compile envoriment
cross_compile="arm-fsl-linux-gnueabi-"

CC="${cross_compile}gcc"
LD="${cross_compile}ld"
AS="${cross_compile}as"
AR="${cross_compile}ar"
CXX="${cross_compile}g++"
STRIP="${cross_compile}strip"
RANLIB="${cross_compile}ranlib"

export CC CXX LD AS AR STRIP RANLIB

# download and extract packets 
#src := libminigui-gpl-3.0.12 minigui-res-be-3.0.12 mg-samples-3.0.12
packets="jpegsrc.v7 libpng-1.2.37 freetype-2.3.9-fm20100818 zlib-1.2.2 \
	libminigui-gpl-3.0.12 minigui-res-be-3.0.12 \
	mg-samples-3.0.12 libmgplus-1.2.4"

prepare ()
{
	[ -d $prefix ] || mkdir $prefix
	[ -d $build ] || mkdir $build
	cd $build

	for i in `ls`; do
		if [ -d ${i} ]; then
			rm -fr ${i}
		fi
	done

	for i in $packets; do
		if [ ! -f ${i}.tar.gz ]; then
			wget http://www.minigui.org/downloads/${i}.tar.gz
		fi
		tar zxf ${i}.tar.gz
	done
}

# depends:
#  libpng (zlib)
#  libmgplus(libminigui)
#  mg-samples(libminigui libmgplus)
install ()
{
	echo -e "\n\n\t\tBuildiing zlib\n"
	cd $build/zlib-1.2.2
	./configure --prefix=$prefix --shared
	make && make install

	echo -e "\n\n\t\tBuildiing jpeg\n"
	cd $build/jpeg-7
	./configure --prefix=$prefix --enable-shared --host=$host
	make && make install

	echo -e "\n\n\t\tBuildiing libpng\n"
	cd $build/libpng-1.2.37
	cp scripts/makefile.linux Makefile
	sed -i "s/AR_RC=ar/AR_RC=${AR}/" Makefile
	sed -i "s/CC=gcc/CC=${CC}/" Makefile
	sed -i "s/RANLIB=ranlib/RANLIB=${RANLIB}/" Makefile
	sed -i "s!prefix=/usr/local!prefix=${prefix}!" Makefile
	sed -i "s/ZLIBLIB=..\/zlib/ZLIBLIB=\$(prefix)\/lib/" Makefile
	sed -i "s/ZLIBINC=..\/zlib/ZLIBINC=\$(prefix)\/include/" Makefile

	./configure --prefix=$prefix --enable-shared --host=$host
	make && make install

	echo -e "\n\n\t\tBuildiing freetype\n"
	cd $build/freetype-2.3.9-fm20100818
	./configure --prefix=$prefix --enable-shared --host=$host
	make && make install

	# no relay to platform
	echo -e "\n\n\t\tBuildiing minigui-resource\n"
	cd $build/minigui-res-be-3.0.12
	./configure --prefix=$prefix
	make && make install

	echo -e "\n\n\t\tBuildiing libminigui\n"
	cp $topdir/p1.patch $build/libminigui-gpl-3.0.12/
	cd $build/libminigui-gpl-3.0.12
	./configure --prefix=$prefix --host=$host
	patch -p0 < p1.patch
	make && make install
	cp src/include/newgal.h $prefix/include/minigui/
	echo "/usr/local/lib" > tmp
	sudo mv tmp /etc/ld.so.conf.d/minigui.conf
	sudo ldconfig 

	echo -e "\n\n\t\tBuildiing libmgplus\n"
	export PKG_CONFIG_PATH=$prefix/lib/pkgconfig
	cd $build/libmgplus-1.2.4
	./configure --prefix=$prefix --host=$host CPPFLAGS="-I${prefix}/include"
	make && make install

	echo -e "\n\n\t\tBuildiing mg-samples\n"
	export PKG_CONFIG_PATH=$prefix/lib/pkgconfig
	cd $build/mg-samples-3.0.12
	./configure --prefix=$prefix --host=$host CFLAGS="-I${prefix}/include"
	make && make install
}

uninstall ()
{
	rm -fr $prefix
}
 
usage ()
{
	echo $"Usage: $0 {prepare|install|uninstall}" 1>&2
}

case "$1" in
	prepare) prepare ;;
	install) install ;;
	uninstall) uninstall ;;
	*) usage ;;
esac


