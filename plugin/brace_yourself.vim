if !exists('g:brace_yourself_default')
    let g:brace_yourself_default = [
                \['{', '}'],
                \['[', ']'],
                \['(', ')'],
                \['"', '"'],
                \['`', '`'],
                \["'", "'"],
                \]
end
if !exists('g:brace_yourself_filetypes')
    let g:brace_yourself_filetypes = {}
end


function! s:setmaps()
    if exists('b:brace_yourself_loaded')
        return
    endif
    let b:bracket_pairs = g:brace_yourself_default
    if has_key(g:brace_yourself_filetypes, &ft)
        let b:bracket_pairs = g:brace_yourself_filetypes[&ft]
    endif

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
        let b:brace_yourself_loaded = 1
    endfor

    if len(b:bracket_pairs) > 0
        inoremap <buffer> <expr> <backspace> brace_yourself#delete_all(b:bracket_pairs)
        inoremap <buffer> <expr> <c-h> brace_yourself#delete_all(b:bracket_pairs)
        inoremap <buffer> <expr> <cr> brace_yourself#expand_all(filter(copy(b:bracket_pairs), 'v:val[0] != v:val[1]'))
        inoremap <buffer> <expr> <c-j> brace_yourself#expand_all(filter(copy(b:bracket_pairs), 'v:val[0] != v:val[1]'))
    end
endfunction

autocmd Filetype * call s:setmaps()
