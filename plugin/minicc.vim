if exists('g:loaded_minicc')
  finish
endif
let g:loaded_minicc = 1

let s:save_cpo = &cpo
set cpo&vim

" Default configuration
if !exists('g:minicc_enabled')
  let g:minicc_enabled = 1
endif

let &cpo = s:save_cpo
unlet s:save_cpo
