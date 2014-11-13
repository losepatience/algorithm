#! /bin/bash

maketags(){
	find `pwd` -name "*.S" -o -name "*.c" -o -name "*.h" > a
	cscope -qbk -i a
	rm -f a
}

case "$1" in
tags)
	maketags
	;;
*)
	echo "Usage: $0 tags"
esac


		
