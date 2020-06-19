let s:undo_str = "\<C-G>U"

function! s:is_alpha_or_num(char)
    return a:char =~ '[^a-zA-Z0-9\d]' 
endfunction

function! brace_yourself#close_bracket(left, right)
    let [_, l:column] =  nvim_win_get_cursor(0)
    let l:line = getline('.')

    let l:next_char = l:line[l:column]


    if s:is_alpha_or_num(l:next_char) || l:next_char == ''
        call nvim_feedkeys(a:left . a:right . s:undo_str . "\<left>", 'n', v:false)
    else
        call nvim_feedkeys(a:left, 'n', v:false)
    endif
endfunction


function! brace_yourself#close_bracket_quote(bracket)
    let [_, l:column] =  nvim_win_get_cursor(0)
    let l:line = getline('.')

    let l:next_char = l:line[l:column]
    let l:prev_char = l:line[l:column-1]


    if l:next_char == a:bracket
        call nvim_feedkeys(s:undo_str."\<right>", "n", v:false)
    else
        if (l:column-1 == -1 || s:is_alpha_or_num(l:prev_char))
                    \ &&
                    \ (s:is_alpha_or_num(l:next_char) || l:next_char == '')
                    \ && l:prev_char != a:bracket
            call nvim_feedkeys(a:bracket . a:bracket . s:undo_str . "\<left>", 'n', v:false)
        else
            call nvim_feedkeys(a:bracket, "n", v:false)
        endif
    end
endfunction

function! brace_yourself#skip_closing(left, right)
    let [_, l:column] =  nvim_win_get_cursor(0)
    let l:line = getline('.')
    let l:next_char = l:line[l:column]

    if l:next_char == a:right
        call nvim_feedkeys(s:undo_str . "\<right>", "n", v:false)
    else
        call nvim_feedkeys(a:right, 'n', v:false)
    end
endfunction

function! brace_yourself#delete_bracket(left, right)
    let [l:row, l:column] =  nvim_win_get_cursor(0)
    let l:line = getline('.')

    let l:next_char = l:line[l:column]
    let l:prev_char = l:line[l:column-1]
    let l:prev_line = getline(l:row-1)
    let l:next_line = getline(l:row+1)

    if l:prev_char == a:left && l:next_char == a:right
        call nvim_feedkeys("\<delete>\<bs>", "n", v:false)
        return v:true
    elseif l:line =~ '^\s*$' && l:prev_line =~ a:left.'$' && l:next_line =~ '^\s*'.a:right
        let l:new_next_line = l:next_line[match(l:next_line, a:right):]
        call setline(l:row+1, l:new_next_line)
        call nvim_feedkeys("\<c-t>\<c-u>\<down>\<bs>\<bs>", "n", v:false)
        return v:true
    else
        return v:false
    end
endfunction


function! brace_yourself#expand(left, right)
    let [_, l:column] =  nvim_win_get_cursor(0)
    let l:line = getline('.')
    let l:next_char = l:line[l:column]
    let l:prev_char = l:line[l:column-1]


    if l:prev_char == a:left && l:next_char == a:right
        call nvim_feedkeys("\<c-j>\<m-O>", "n", v:false)
        return v:true
    else
        return v:false
    end
endfunction

function! brace_yourself#expand_all(bracket_pairs)
    for [l:left, l:right] in a:bracket_pairs
        if brace_yourself#expand(left, right)
            return v:true
        end
    endfor
    call nvim_feedkeys("\<c-j>", 'n', v:false)
    return v:false
endfunction

function! brace_yourself#delete_all(bracket_pairs)
    for [l:left, l:right] in a:bracket_pairs
        if brace_yourself#delete_bracket(left, right)
            return v:true
        end
    endfor
    call nvim_feedkeys("\<bs>", 'n', v:false)
    return v:false
endfunction
