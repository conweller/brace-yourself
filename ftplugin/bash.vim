let brackets = [['<', '>'], ['[', ']'], ['(', ')'], ['{', '}'], ["'", "'"], ['"', '"']]
"""" MAPPINGS
" Function to auto complete brackets
" I know this function's gross, I'll organize it later'
" function! Matching(var)
" 	if a:var==1
" 		inoremap <expr> ) (MatchVar(')')? '<esc>la':')')
" 		inoremap <expr> } (MatchVar('}')? '<esc>la':'}')
" 		inoremap <expr> ] (MatchVar(']')? '<esc>la':']')
" 		inoremap <expr> > (MatchVar('>')? '<esc>la':'>')
" 		inoremap <expr> " (MatchVar('"')? '<esc>la':'""<esc>i')
" 		inoremap <expr> ' (MatchVar("'")? '<esc>la':"''<esc>i")
" 		inoremap <expr> <Backspace> (DeleteBoth(brackets)? '<Delete><C-h>':'<C-h>') 
" 		inoremap <expr> <CR> (IndentCR()? '<C-j><C-j><esc>kddkA<C-j>':'<C-j>')
" 		inoremap { {}<ESC>i
" 		inoremap ( ()<ESC>i
" 		inoremap [ []<Esc>i
" 	elseif a:var==0
" 		iunmap {
" 		iunmap (
" 		iunmap [
" 		iunmap <expr> )
" 		iunmap <expr> }
" 		iunmap <expr> ]
" 		iunmap <expr> >
" 		iunmap <expr> '
" 		iunmap <expr> "
" 		iunmap <expr> <Backspace>
" 		iunmap <expr> <CR>
" 	endif
" endfunction



" " if match_status=1, complete is on, if 0 its off
" let s:match_status = 1 

" " turn auto matching off or on, map to co in norm mode
" function! Set_comp()
" 	call Matching(s:match_status)
" 	let s:match_status = ((s:match_status+1)%2)
" endfunction

" nnoremap co :call Set_comp()<CR>

" " turn on matching by default
" call Set_comp()
