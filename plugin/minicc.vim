if exists('g:loaded_minicc')
  finish
endif
let g:loaded_minicc = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:minicc_pane')
  let g:minicc_pane = ''
endif

command! -nargs=+ MiniCC       call minicc#send(<q-args>)
command! -nargs=0 MiniCCLine   call minicc#send_line()
command! -nargs=0 -range MiniCCRange  call minicc#send_range(<line1>, <line2>)
command! -nargs=0 -range MiniCCSmart call minicc#send_smart(<line1>, <line2>)
command! -nargs=+ MiniCCLinePrompt  call minicc#send_line_prompt(<q-args>)
command! -nargs=+ -range MiniCCRangePrompt call minicc#send_range_prompt(<line1>, <line2>, <q-args>)
command! -nargs=+ -range MiniCCSmartPrompt call minicc#send_smart_prompt(<line1>, <line2>, <q-args>)
command! -nargs=0 MiniCCTarget       call minicc#target()
command! -nargs=0 MiniCCReload      call minicc#reload_all()
command! -nargs=0 MiniCCCaptureRefs call minicc#capture_refs()
command! -nargs=0 MiniCCInterrupt  call minicc#interrupt()

let &cpo = s:save_cpo
unlet s:save_cpo
