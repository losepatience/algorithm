#! /bin/bash

sudo yum install vim vim-X11 global cscope ctags
cp .vim ~/ -a
cp /usr/share/gtags/{gtags.vim,gtags-cscope.vim} ~/.vim/plugin
cp .vimrc ~/
