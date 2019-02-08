"=============================================================================
" File: commentout.vim
" Author: nenokida 
" Created: 2019-02-08
"=============================================================================

scriptencoding utf-8

if !exists('g:loaded_commentout')
    finish
endif
let g:loaded_commentout = 1

let s:save_cpo = &cpo
set cpo&vim

nnoremap <C-_> :<C-u>call commentout#Commentout(v:count1)<CR>
vnoremap <C-_> :call commentout#CommentoutVmode()<CR>


let &cpo = s:save_cpo
unlet s:save_cpo
