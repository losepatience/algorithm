#! /bin/bash

maketags ()
{
	find `pwd` -name "*.S" -o -name "*.c" -o -name "*.h" > .tmp_tagfile
	cscope -qbk -i .tmp_tagfile
	rm -f .tmp_tagfile
}

maketags

