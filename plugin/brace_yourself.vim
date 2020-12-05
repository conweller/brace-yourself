if !exists('g:brace_yourself_ft_ignore')
    let g:brace_yourself_ft_ignore = []
end

let g:bracket_pairs = [
            \['{', '}'],
            \['[', ']'],
            \['(', ')'],
            \['"', '"'],
            \['`', '`'],
            \["'", "'"],
            \]

function! s:setmaps()
    if index(g:brace_yourself_ft_ignore, &ft) > 0
        return
    end
    if !exists('b:bracket_pairs')
        let b:bracket_pairs = g:bracket_pairs
    end

    for [s:left, s:right] in b:bracket_pairs
        if s:left != s:right
            exe "inoremap <buffer> <expr> " . s:left
                        \ . " brace_yourself#close_bracket('"
                        \ . s:left . "','" . s:right . "')"
            exe "inoremap <buffer> <expr> " . s:right
                        \ . " brace_yourself#skip_closing('"
                        \ . s:left . "','" . s:right . "')"
        else
            if s:left =~ "'"
                exe 'inoremap <buffer> <expr> ' . s:left
                            \ . ' brace_yourself#close_bracket_quote("'
                            \ . s:left . '")'
            else
                exe "inoremap <buffer> <expr> " . s:left
                            \ . " brace_yourself#close_bracket_quote('"
                            \ . s:left . "')"
            endif
        endif
    endfor

    inoremap <buffer> <expr> <backspace> brace_yourself#delete_all(b:bracket_pairs)
    inoremap <buffer> <expr> <c-h> brace_yourself#delete_all(b:bracket_pairs)
    inoremap <buffer> <expr> <cr> brace_yourself#expand_all(b:bracket_pairs)
    inoremap <buffer> <expr> <c-j> brace_yourself#expand_all(b:bracket_pairs)
endfunction

autocmd BufEnter * call s:setmaps()
