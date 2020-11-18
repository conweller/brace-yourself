let g:bracket_pairs = [
            \['{', '}'],
            \['[', ']'],
            \['(', ')'],
            \['"', '"'],
            \['`', '`'],
            \["'", "'"],
            \]
let g:closing_brackets = [ '}', ']', ')', '"', '"']

for [s:left, s:right] in g:bracket_pairs
    if s:left != s:right
        exe "inoremap <expr> " . s:left
                    \ . " brace_yourself#close_bracket('"
                    \ . s:left . "','" . s:right . "')"
        exe "inoremap <expr> " . s:right
                    \ . " brace_yourself#skip_closing('"
                    \ . s:left . "','" . s:right . "')"
    else
        if s:left =~ "'"
            exe 'inoremap <expr> ' . s:left
                        \ . ' call brace_yourself#close_bracket_quote("'
                        \ . s:left . '")'
        else
            exe "inoremap <expr> " . s:left
                        \ . " call brace_yourself#close_bracket_quote('"
                        \ . s:left . "')"
        endif
    endif
endfor

inoremap <expr> <backspace> brace_yourself#delete_all(g:bracket_pairs)
inoremap <expr> <c-h> brace_yourself#delete_all(g:bracket_pairs)
inoremap <expr> <cr> brace_yourself#expand_all(g:bracket_pairs)
inoremap <expr> <c-j> brace_yourself#expand_all(g:bracket_pairs)
