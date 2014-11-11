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
env)
	~/altera/13.0sp1/embedded/embedded_command_shell.sh
	;;
*)
	echo "Usage: $0 [tags|env}"
esac


		
