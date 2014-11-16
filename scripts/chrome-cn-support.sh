#! /bin/bash

F=`which google-chrome`

if [[ ! $? -eq 0 ]]; then
	echo "install google-chrome first."
	exit 2
fi

grep 'LANG="zh_CN.UTF-8"' $F > /dev/null 2>&1

if [[ $? -eq 0 ]]; then
	exit 1
fi

sudo sed -i '/export CHROME_WRAPPER="`readlink -f "$0"`"/aLANG="zh_CN.UTF-8"' $F
