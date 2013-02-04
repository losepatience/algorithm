"========================================================
" Highlight All Function
"========================================================
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>[^()]*)("me=e-2
syn match cFunctions "\<[a-zA-Z_][a-zA-Z_0-9]*\>\s*("me=e-1
hi cFunctions gui=NONE guifg=#B5A1FF cterm=bold ctermfg=lightblue
"hi cFunction gui=NONE guifg=#B5A1FF ctermfg=green

"========================================================
" Highlight All Math Operator
"========================================================
syn match cMathOperator		display "[-+\*/%=]"
syn match cPointerOperator	display "->\|\."
syn match cLogicalOperator	display "[!<>]=\="
syn match cLogicalOperator	display "=="
syn match cBinaryOperator	display "\(&\||\|\^\|<<\|>>\)=\="
syn match cBinaryOperator	display "\~"
syn match cBinaryOperator	display "\~="
syn match cLogicalOperator	display "&&\|||"
syn match cLogicalOperator	display "\(&&\|||\)="

" Math Operator
hi cMathOperator	guifg=#3EFFE2 cterm=bold ctermfg=magenta
hi cPointerOperator	guifg=#3EFFE2 cterm=bold ctermfg=magenta
hi cLogicalOperator	guifg=#3EFFE2 cterm=bold ctermfg=magenta
hi cBinaryOperator	guifg=#3EFFE2 cterm=bold ctermfg=magenta
hi cLogicalOperator	guifg=#3EFFE2 cterm=bold ctermfg=magenta

