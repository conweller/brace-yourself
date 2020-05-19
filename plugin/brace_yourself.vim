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
        exe "imap ".s:left." <cmd>call brace_yourself#close_bracket('".s:left."','".s:right."')<cr>"
        exe "imap ".s:right." <cmd>call brace_yourself#skip_closing('".s:left."','".s:right."')<cr>"
    else
        if s:left =~ "'"
            exe 'imap '.s:left.' <cmd>call brace_yourself#close_bracket_quote("'.s:left.'")<cr>'
        else
            exe "imap ".s:left." <cmd>call brace_yourself#close_bracket_quote('".s:left."')<cr>"
        endif
    endif
endfor

imap <backspace> <cmd>call brace_yourself#delete_all(g:bracket_pairs)<cr>
imap <cr> <cmd>call brace_yourself#expand_all(g:bracket_pairs)<cr>

