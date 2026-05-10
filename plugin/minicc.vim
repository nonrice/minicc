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
command! -nargs=0 -range MiniCCRef call minicc#send_smart(<line1>, <line2>)
command! -nargs=+ -range MiniCCRefPrompt call minicc#send_smart_prompt(<line1>, <line2>, <q-args>)
command! -nargs=0 MiniCCTarget       call minicc#target()
command! -nargs=0 MiniCCReload      call minicc#reload_all()
command! -nargs=0 MiniCCCaptureRefs call minicc#capture_refs()

let &cpo = s:save_cpo
unlet s:save_cpo
