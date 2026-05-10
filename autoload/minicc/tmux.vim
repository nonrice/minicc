let s:save_cpo = &cpo
set cpo&vim

let s:pane_id = ''

function! minicc#tmux#find_pane() abort
  if s:pane_id !=# ''
    let existing = system('tmux list-panes -a -F "#{pane_id}"')
    if stridx(existing, s:pane_id) >= 0
      return s:pane_id
    endif
    let s:pane_id = ''
  endif

  let lines = systemlist('tmux list-panes -a -F "#{pane_id} #{pane_current_command}"')
  for line in lines
    if line =~# '\<claude\>'
      let s:pane_id = split(line)[0]
      return s:pane_id
    endif
  endfor
  return ''
endfunction

function! minicc#tmux#resolve_pane() abort
  if exists('g:minicc_pane') && g:minicc_pane !=# ''
    return g:minicc_pane
  endif
  let pane = minicc#tmux#find_pane()
  if pane ==# ''
    echohl ErrorMsg | echom 'minicc: no Claude pane detected' | echohl None
  endif
  return pane
endfunction

function! minicc#tmux#send(pane_id, text) abort
  call system('tmux send-keys -l -t ' . shellescape(a:pane_id) . ' ' . shellescape(a:text))
  call system('tmux send-keys -t ' . shellescape(a:pane_id) . ' Enter')
endfunction

function! minicc#tmux#type(pane_id, text) abort
  call system('tmux send-keys -l -t ' . shellescape(a:pane_id) . ' ' . shellescape(a:text))
endfunction

function! minicc#tmux#focus(pane_id) abort
  call system('tmux select-pane -t ' . shellescape(a:pane_id))
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

