" cheatsheet.vim - Show buffer-specific reminders in a popup window.
" Author: Gábor Nyéki
" Version: 1.0

if exists("g:loaded_cheatsheet") || &cp
    finish
endif
let g:loaded_cheatsheet = v:true

let s:popup_winid = v:null

function! s:toggle_popup()
    if has("nvim")
        echoerr "Not yet implemented for Neovim."
    elseif s:popup_winid isnot v:null
        call popup_close(s:popup_winid)
        let s:popup_winid = v:null
    elseif !exists("b:cheatsheet")
        echomsg "Set `b:cheatsheet` to enable vim-cheatsheet."
    else
        let s:popup_winid = popup_create(
                    \   b:cheatsheet,
                    \   #{
                    \     padding: [1, 1, 1, 1],
                    \     border: [1, 1, 1, 1]
                    \   }
                    \ )
    endif
endfunction

nnoremap <Plug>ToggleCheatsheet :call <SID>toggle_popup()<CR>

if !exists("g:cheatsheet_no_mappings") || !g:cheatsheet_no_mappings
   nmap <silent> <Leader>C <Plug>ToggleCheatsheet
endif
