" cheatsheet.vim - Show buffer-specific reminders in a popup window.
" Author: Gábor Nyéki
" Version: 1.1

if exists("g:loaded_cheatsheet") || &cp
    finish
endif
let g:loaded_cheatsheet = v:true

let s:popup_winid = v:null

function! s:toggle_popup()
    if s:popup_winid isnot v:null
        call s:popup_close(s:popup_winid)
        let s:popup_winid = v:null
    elseif !exists("b:cheatsheet_lines")
        echomsg "Set `b:cheatsheet_lines` to enable vim-cheatsheet."
    else
        if exists("b:cheatsheet_title")
            let l:title = b:cheatsheet_title
        else
            let l:title = ""
        endif

        let s:popup_winid = s:popup_create(
                    \   l:title,
                    \   b:cheatsheet_lines
                    \ )
    endif
endfunction

function! s:popup_close(winid)
    if has("nvim")
        call nvim_win_close(a:winid, v:false)
    else
        call popup_close(a:winid)
    endif
endfunction

function! s:popup_create(title, lines)
    if has("nvim")
        let l:n_rows = len(a:lines)
        let l:n_cols = s:max_len(a:lines + [a:title])
        let l:buf = nvim_create_buf(v:false, v:true)

        call nvim_buf_set_lines(l:buf, 0, -1, v:true, a:lines)
        call nvim_set_option_value("readonly", v:true, #{buf: l:buf})

        return nvim_open_win(
                    \   l:buf,
                    \   0,
                    \   #{
                    \     title: a:title,
                    \     border:
                    \       ["╔", "═","╗", "║", "╝", "═", "╚", "║"],
                    \     relative: "cursor",
                    \     row: 1,
                    \     col: 0,
                    \     width: l:n_cols,
                    \     height: l:n_rows,
                    \     style: "minimal",
                    \     anchor: "NW",
                    \   }
                    \ )
    else
        return popup_create(
                    \   a:lines,
                    \   #{
                    \     title: a:title,
                    \     border: [1, 1, 1, 1],
                    \     line: "cursor+1",
                    \     col: "cursor",
                    \   }
                    \ )
    endif
endfunction

" Calculates the length of the longest string in the provided list.
function! s:max_len(strings)
    let l:max = v:null

    for l:string in a:strings
        let l:this = len(l:string)

        if l:max is v:null || l:max < l:this
            let l:max = l:this
        endif
    endfor

    return l:max
endfunction

nnoremap <Plug>ToggleCheatsheet :call <SID>toggle_popup()<CR>

if !exists("g:cheatsheet_no_mappings") || !g:cheatsheet_no_mappings
   nmap <silent> <Leader>C <Plug>ToggleCheatsheet
endif
