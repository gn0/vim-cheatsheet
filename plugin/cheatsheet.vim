" cheatsheet.vim - Show buffer-specific reminders in a popup window.
" Location: plugin/cheatsheet.vim
" Author: Gábor Nyéki
" Version: 1.1
" License: CC0

if exists("g:loaded_cheatsheet") || &cp
    finish
endif
let g:loaded_cheatsheet = v:true

nnoremap <Plug>ToggleCheatsheet :call cheatsheet#toggle_popup()<CR>

if !exists("g:cheatsheet_no_mappings") || !g:cheatsheet_no_mappings
   nmap <silent> <Leader>C <Plug>ToggleCheatsheet
endif
