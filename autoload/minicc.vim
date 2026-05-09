let s:save_cpo = &cpo
set cpo&vim

function! minicc#setup() abort
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
