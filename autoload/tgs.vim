" autoload/tgs.vim
" Copyright (c) 2020 Hiroki Konishi <relastle@gmail.com>
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.

let s:bin_dir = expand('<sfile>:h:h') . '/python3/bin/'

"---------------------------------------
" List
"---------------------------------------
let s:bin_list_ctags = s:bin_dir . 'list_ctags.py'

function! tgs#get_source_cmd() abort
  let l:tags = tagfiles()
  if empty(l:tags)
    return ''
  endif

  let l:tag = l:tags[0]
  return printf('python3 %s %s', s:bin_list_ctags, l:tag)
endfunction

" This function is implemented by referring to
" https://github.com/junegunn/fzf.vim
function! tgs#list_sink_function(line) abort
  let l:elms = split(a:line, ":\t")
  let l:filepath = l:elms[1]
  let l:pat = l:elms[2][:-3]
  if len(l:elms) < 4
    let l:tag_path = '.'
  else
    let l:tag_path = l:elms[3]
  endif
  let l:target_path = join([l:tag_path, l:filepath], '/')
  try
    let [magic, &magic, wrapscan, &wrapscan, autochdir, &autochdir] = [&magic, 0, &wrapscan, 1, &autochdir, 0]
    execute 'e' fnameescape(l:target_path)
    silent execute l:pat
  finally
    let [&magic, &wrapscan, &autochdir] = [magic, wrapscan, autochdir]
  endtry
endfunction

function! tgs#list() abort
  let l:cmd = tgs#get_source_cmd()
  if empty(l:cmd)
    echom 'Please make sure you have already created `tag` file'
    return
  endif
  let l:wrapped = fzf#wrap(extend({
        \ 'source': l:cmd,
        \ 'options': ['--ansi', '-d', ':\t', '--nth', '1..3'],
        \ 'sink': function('tgs#list_sink_function'),
        \ }, get(g:, 'fzf_layout', {})))
  call fzf#run(l:wrapped)
endfunction

"---------------------------------------
" Jump
"---------------------------------------
"
python3 << EOF
import vim
from tgs_vim_if import *
EOF

function! tgs#jump_sink_function(line) abort
  let l:elms = split(a:line, ': ')
  let l:count = l:elms[0]
  let l:icon_and_name = l:elms[1]
  let l:name = split(l:icon_and_name, ' ')[1]
  execute printf('%s tag %s', l:count, l:name)
endfunction

function! tgs#jump() abort
  let l:word = expand('<cword>')
  let l:candidate = taglist(printf('^%s$', l:word))

  if empty(l:candidate)
    " Case for no tag was found.
    echom printf('No tag was found for `%s`', l:word)
    return
  endif

  if len(l:candidate) == 1
    " Jump to an single tag found.
    execute 'tag' l:word
    return
  endif

  " Select tag to jump from multiples tags found.
  let l:py_expr = 'get_source_from_candidates(' . string(l:candidate) . ')'
  let l:source = py3eval(l:py_expr)
  let l:wrapped = fzf#wrap(extend({
        \ 'source': l:source,
        \ 'options': ['--ansi', '-d', ': ', '--nth', '2..4'],
        \ 'sink': function('tgs#jump_sink_function'),
        \ }, get(g:, 'fzf_layout', {})))
  call fzf#run(l:wrapped)
endfunction
