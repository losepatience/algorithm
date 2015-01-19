""""""""""""""""""""""""""""""
" Common setting
""""""""""""""""""""""""""""""
filetype plugin indent on
syntax enable
syntax on
set fileencodings=ucs-bom,utf-8,gbk,latin1
set nocompatible
colorscheme desert
set go= " No menu
set showcmd
set ruler
set nu
set shiftwidth=8
set tabstop=8
set textwidth=78
set smarttab
set formatoptions=tcqlron
set cinoptions=:0,l1,t0,g0
set completeopt=longest,menu
" set ai si
" set foldmethod=syntax

""""""""""""""""""""""""""""""
" No bells
""""""""""""""""""""""""""""""
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

""""""""""""""""""""""""""""""
" Maximize when open
""""""""""""""""""""""""""""""
au GUIEnter * call MaximizeWindow()
function! MaximizeWindow()
    " sleep 1
    " silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
    " silent !wmctrl -r :ACTIVE: -b add,fullscreen
    silent :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")
endfunction
map <silent> <F11>
\ :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

""""""""""""""""""""""""""""""
" Setting Font 
""""""""""""""""""""""""""""""
if has("gui_running")
    if has("unix")
        set guifont=Monospace\ 16
        set guifontwide=KaiTi\ 16
    elseif has("win32")
        set guifont=Courier:h12:cANSI
        set guifontwide=NSimSun:h12 
    endif
endif


""""""""""""""""""""""""""""""
" Taglist
""""""""""""""""""""""""""""""
let g:NERDTree_title="[NERDTree]"  
let Tlist_Show_One_File=1		" only current file 
let Tlist_Exit_OnlyWindow=1		" exit vim
let Tlist_File_Fold_Auto_Close=1	" fold up inactive files
let Tlist_Show_Menu=1			" display taglist's menu
"let Tlist_Use_Right_Window=1
"let Tlist_Auto_Open=1			

""""""""""""""""""""""""""""""
" NERDTree 
""""""""""""""""""""""""""""""
let NERDTreeChDirMode=2
let NERDTreeShowBookmarks=1
let NERDTreeDirArrows=1
let NERDTreeQuitOnOpen=1
" let NERDTreeShowLineNumbers=1
" let NERDTreeMinimalUI=1
" let NERDTreeShowHidden=1
" let g:nerdtree_tabs_open_on_gui_startup=0
" let g:nerdtree_tabs_open_on_console_startup=0

""""""""""""""""""""""""""""""
" BufExplorer
""""""""""""""""""""""""""""""
let g:bufExplorerSortBy='mru'
let g:bufExplorerSplitRight=0
let g:bufExplorerSplitVertical=1
let g:bufExplorerSplitVertSize=20
let g:bufExplorerUseCurrentWindow=1
autocmd BufWinEnter \[Buf\ List\] setl nonumber

""""""""""""""""""""""""""""""
" winmanager
""""""""""""""""""""""""""""""
let g:winManagerWindowLayout="NERDTree|TagList"
let g:winManagerWidth=30
nmap wm :WMToggle<cr>

""""""""""""""""""""""""""""""
" Grep and ^+xi-^+o
""""""""""""""""""""""""""""""
nnoremap <silent> <F3> :Grep<CR>
let g:SuperTabRetainCompletionType=2
let g:SuperTabDefaultCompletionType="<C-X><C-O>"


""""""""""""""""""""""""""""""
" cscope
""""""""""""""""""""""""""""""
" replace cscope with gnu global 
let GtagsCscope_Auto_Map = 1
let GtagsCscope_Absolute_Path = 1
let GtagsCscope_Auto_Load = 1
let g:Gtags_Auto_Update = 1
let GtagsCscope_Quiet = 1
set cscopetag

" set cscopequickfix=s-,c-,d-,i-,t-,e-
" if has("cscope")
" 	set csprg=/usr/bin/cscope
" 	set csto=1	" first tags, then cscope.out
" 	set cst		" use ":cs find g", not ":tag"
" 	set nocsverb	" not echo link info
" 	set cspc=3	" the last 3 node of path
" 	if filereadable("cscope.out")
" 		cs add cscope.out
" 	else "search cscope.out elsewhere
" 		let cscope_file=findfile("cscope.out", ".;")
" 		if !empty(cscope_file) && filereadable(cscope_file)
" 			exec "cs add" cscope_file
" 		endif      
" 	endif
" 	set csverb	" reset to the default  
" endif

" nnoremap <C-\>s :cs f s <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>g :cs f g <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>c :cs f c <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>t :cs f t <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>e :cs f e <C-R>=expand("<cword>")<CR><CR>
" nnoremap <C-\>f :cs f f <C-R>=expand("<cfile>")<CR><CR>
" nnoremap <C-\>i :cs f i <C-R>=expand("<cfile>")<CR><CR>
" nnoremap <C-\>d :cs f d <C-R>=expand("<cword>")<CR><CR>

map <F12> :set paste
\<CR>ggO/* ~.~ *-c-*
\<CR> *
\<CR> * Copyright (c) 2013, John Lee <furious_tauren@163.com>
\<CR> * <Esc>:read !date<CR>kJ$a
\<CR> *
\<CR> * This program is free software; you can redistribute it and/or
\<CR> * modify it under the terms of the GNU General Public License as
\<CR> * published by the Free Software Foundation; either version 2 of
\<CR> * the License, or (at your option) any later version.
\<CR> *
\<CR> * This program is distributed in the hope that it will be useful,
\<CR> * but WITHOUT ANY WARRANTY; without even the implied warranty of
\<CR> * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
\<CR> * GNU General Public License for more details.
\<CR> *
\<CR> * You should have received a copy of the GNU General Public License
\<CR> * along with this program; if not, write to the Free Software
\<CR> * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
\<CR> * MA 02111-1307 USA
\<CR> */
\<CR><esc> :set nopaste<CR>

""""""""""""""""""""""""""""""
" ctags
""""""""""""""""""""""""""""""
set autochdir
set tags=tags;

" http://stackoverflow.com/questions/2182427/right-margin-in-vim
function! s:ToggleColorColumn()
  if s:color_column_old == 0
    let s:color_column_old = &colorcolumn
    windo let &colorcolumn = 0
  else
    windo let &colorcolumn=s:color_column_old
    let s:color_column_old = 0
  endif
endfunction

if exists('+colorcolumn')
  set colorcolumn=81
  let s:color_column_old = 0
  nnoremap <Leader>m :call <SID>ToggleColorColumn()<cr>
endif
 
auto bufread ~/workspace/avs/* so ~/.wvimrc
