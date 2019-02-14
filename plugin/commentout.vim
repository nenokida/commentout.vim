"=============================================================================
" File: commentout.vim
" Author: nenokida
" Created: 2019-02-08
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_commentout')
    finish
endif
let g:loaded_commentout = 1

let s:save_cpo = &cpo
set cpo&vim

let s:comment_map = { 
    \   "c": '\/\/',
    \   "cpp": '\/\/',
    \   "go": '\/\/',
    \   "java": '\/\/',
    \   "javascript": '\/\/',
    \   "lua": '--',
    \   "scala": '\/\/',
    \   "php": '\/\/',
    \   "python": '#',
    \   "ruby": '#',
    \   "rust": '\/\/',
    \   "sh": '#',
    \   "desktop": '#',
    \   "fstab": '#',
    \   "conf": '#',
    \   "profile": '#',
    \   "bashrc": '#',
    \   "bash_profile": '#',
    \   "mail": '>',
    \   "eml": '>',
    \   "bat": 'REM',
    \   "ahk": ';',
    \   "vim": '"',
    \   "tex": '%',
    \ }


function! commentout#CommentoutVmode()
   if has_key(s:comment_map, &filetype)
       let comment_leader = s:comment_map[&filetype]
       if getline('.') =~ "^\\s*" . comment_leader . " " 
           " Uncomment the line
           execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
       else 
           if getline('.') =~ "^\\s*" . comment_leader
               " Uncomment the line
               execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
           else
               " Comment the line
               execute "silent s/^\\(\\s*\\)/" . comment_leader . " \\1/"
           end
       end
   else
       echo "No comment leader found for filetype"
   end
endfunction

nnoremap <C-_> :<C-u>call commentout#Commentout(v:count1)<CR>

function! commentout#Commentout(count)
  let cnt = v:count1
  let end = line('$')
  let now = line('.')
  let cc = end - now
  if cc < cnt
    let cnt = cc 
  endif  
  if has_key(s:comment_map, &filetype)
    let comment_leader = s:comment_map[&filetype]
    " if one row
    if cnt == 1
        if getline('.') =~ "^\\s*" . comment_leader . " " 
           " Uncomment the line
           execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
       else 
           if getline('.') =~ "^\\s*" . comment_leader
               " Uncomment the line
               execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
           else
               " Comment the line
               execute "silent s/^\\(\\s*\\)/" . comment_leader . " \\1/"
           end
       end
       " if multi rows
    elseif 
      let i = 0
      for a in range(cnt)
        if getline('.') =~ "^\\s*" . comment_leader . " " ||getline('.') =~ "^\\s*" . comment_leader 
          let i += 1
          "        i+=1
        endif
        execute "normal! j<CR>"
      endfor
      execute "normal!" (cnt) . "k"

      if i == cnt
        " Uncomment the line
        for a in range(cnt)
          " With space
          if getline('.') =~ "^\\s*" . comment_leader . " " 
            execute "silent s/^\\(\\s*\\)" . comment_leader . " /\\1/"
          elseif getline('.') =~ "^\\s*" . comment_leader
            execute "silent s/^\\(\\s*\\)" . comment_leader . "/\\1/"
          endif
          execute "normal! j<CR>"
        endfor
        execute "normal!" (cnt) . "k"
      else 
        " Comment the line
        for a in range(cnt)
          execute "silent s/^\\(\\s*\\)/" . comment_leader . " \\1/"
          execute "normal! j<CR>"
        endfor
        execute "normal!" (cnt - 0) . "k"
      endif
    endif
  else
    echo "No comment leader found for filetype"
  endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
