let s:save_cpo = &cpo
set cpo&vim

function! minicc#send(text) abort
  let pane = minicc#tmux#resolve_pane()
  if pane ==# ''
    return
  endif
  call minicc#tmux#send(pane, a:text)
  call minicc#tmux#focus(pane)
endfunction

function! minicc#type(text) abort
  let pane = minicc#tmux#resolve_pane()
  if pane ==# ''
    return
  endif
  call minicc#tmux#type(pane, a:text)
  call minicc#tmux#focus(pane)
endfunction

function! minicc#send_line() abort
  silent! write
  let ref = '@' . expand('%:p') . ':' . line('.')
  call minicc#type(ref)
endfunction

function! minicc#send_range(line1, line2) abort
  silent! write
  let ref = '@' . expand('%:p') . ':' . a:line1 . '-' . a:line2
  call minicc#type(ref)
endfunction

function! minicc#send_smart(line1, line2) abort
  if a:line1 == a:line2
    call minicc#send_line()
  else
    call minicc#send_range(a:line1, a:line2)
  endif
endfunction

function! minicc#send_line_prompt(text) abort
  silent! write
  let ref = '@' . expand('%:p') . ':' . line('.')
  call minicc#send(ref . ' ' . a:text)
endfunction

function! minicc#send_range_prompt(line1, line2, text) abort
  let ref = '@' . expand('%:p') . ':' . a:line1 . '-' . a:line2
  call minicc#send(ref . ' ' . a:text)
endfunction

function! minicc#send_smart_prompt(line1, line2, text) abort
  if a:line1 == a:line2
    call minicc#send_line_prompt(a:text)
  else
    call minicc#send_range_prompt(a:line1, a:line2, a:text)
  endif
endfunction

function! minicc#reload_all() abort
  let unsaved = []
  for nr in range(1, bufnr('$'))
    if buflisted(nr) && bufname(nr) !=# '' && getbufvar(nr, '&buftype') ==# '' && getbufvar(nr, '&modified')
      call add(unsaved, fnamemodify(bufname(nr), ':~:.'))
    endif
  endfor
  if !empty(unsaved)
    echohl ErrorMsg
    echom 'minicc: unsaved changes in: ' . join(unsaved, ', ')
    echohl None
    return 0
  endif
  let save_ar = &autoread
  set autoread
  for nr in range(1, bufnr('$'))
    if buflisted(nr) && bufname(nr) !=# '' && getbufvar(nr, '&buftype') ==# ''
      execute 'checktime ' . nr
    endif
  endfor
  let &autoread = save_ar
  return 1
endfunction


function! minicc#capture_refs() abort
  let pane = minicc#tmux#resolve_pane()
  if pane ==# ''
    return
  endif
  if !minicc#reload_all()
    return
  endif
  let lines = systemlist('tmux capture-pane -p -S -1000 -t ' . shellescape(pane))
  let pane_cwd = trim(system('tmux display-message -p -t ' . shellescape(pane) . ' "#{pane_current_path}"'))

  " Find last prompt boundary (❯) and keep only lines after it
  let boundary = -1
  for i in range(len(lines) - 1, 0, -1)
    if lines[i] =~# '^\s*❯\s\+\S'
      let boundary = i
      break
    endif
  endfor
  let lines = boundary >= 0 ? lines[boundary + 1 :] : lines

  let entries = []
  let cur_file = ''
  let in_hunk = 0

  for line in lines
    let path = matchstr(line, 'Update(\zs[^)]\+\ze)')
    if path !=# ''
      let cur_file = (path =~# '^/') ? path : pane_cwd . '/' . path
      let in_hunk = 0
      continue
    endif
    let path = matchstr(line, 'Write(\zs[^)]\+\ze)')
    if path !=# ''
      let abs = (path =~# '^/') ? path : pane_cwd . '/' . path
      call add(entries, {'filename': abs, 'lnum': 1, 'text': 'Claude write'})
      let cur_file = ''
      continue
    endif
    if cur_file !=# ''
      let diff_match = matchlist(line, '\(\d\+\)\s\+[│ ]*+')
      if !empty(diff_match)
        if !in_hunk
          call add(entries, {'filename': cur_file, 'lnum': str2nr(diff_match[1]), 'text': 'Claude edit'})
          let in_hunk = 1
        endif
      else
        let in_hunk = 0
      endif
    endif
  endfor

  call setqflist([], 'r', {'title': 'Claude edits', 'items': entries})
  if !empty(entries)
    copen
  else
    echom 'minicc: no Claude edits found after last prompt'
  endif
endfunction

function! minicc#interrupt() abort
  let pane = minicc#tmux#resolve_pane()
  if pane ==# ''
    return
  endif
  call system('tmux send-keys -t ' . shellescape(pane) . ' C-c')
endfunction

function! minicc#target() abort
  let pane = minicc#tmux#resolve_pane()
  if pane !=# ''
    echom 'minicc: Claude pane is ' . pane
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
