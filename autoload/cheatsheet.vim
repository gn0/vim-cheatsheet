" Location: autoload/cheatsheet.vim

if exists("g:autoloaded_cheatsheet") || &cp
    finish
endif
let g:autoloaded_cheatsheet = v:true

let s:popup_winid = v:null

function! cheatsheet#toggle_popup()
    if s:popup_winid isnot v:null
        call cheatsheet#popup_close(s:popup_winid)
        let s:popup_winid = v:null
    elseif !exists("b:cheatsheet_lines")
        echomsg "Set `b:cheatsheet_lines` to enable vim-cheatsheet."
    else
        if exists("b:cheatsheet_title")
            let l:title = b:cheatsheet_title
        else
            let l:title = ""
        endif

        let s:popup_winid = cheatsheet#popup_create(
                    \   l:title,
                    \   b:cheatsheet_lines
                    \ )
    endif
endfunction

function! cheatsheet#popup_close(winid)
    if has("nvim")
        call nvim_win_close(a:winid, v:false)
    else
        call popup_close(a:winid)
    endif
endfunction

function! cheatsheet#popup_create(title, lines)
    if has("nvim")
        let l:n_rows = len(a:lines)
        let l:n_cols = max(map(a:lines + [a:title], "len(v:val)"))
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
