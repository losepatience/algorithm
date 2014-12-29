#! /bin/sh

maketags()
{
  find `pwd` -name "*.[hcS]" -o -name "*.cpp" > gtags.file
  gtags
}

maketags

