#! /bin/sh

sudo yum install -y vim vim-X11 global cscope ctags

cp .vim ~/ -a
cp /usr/share/gtags/{gtags.vim,gtags-cscope.vim} ~/.vim/plugin

cp .vimrc ~/
