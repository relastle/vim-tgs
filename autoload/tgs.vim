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

let s:bin_dir = expand('<sfile>:h:h') . '/bin/'
let s:bin_presenter = s:bin_dir . 'presenter.py'

function! tgs#get_source_cmd() abort
  let l:tags = tagfiles()
  if empty(l:tags)
    echom 'Please make sure you have already created `tag` file'
    return
  endif

  let l:tag = l:tags[0]
  return printf('python3 %s %s', s:bin_presenter, l:tag)
endfunction

function! tgs#sink_function(line) abort
  let l:elms = split(a:line, ': ')
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

function! tgs#tags() abort
  let l:wrapped = fzf#wrap(extend({
        \ 'source': tgs#get_source_cmd(),
        \ 'options': ['--ansi', '-d', ': ', '--nth', '1,2'],
        \ 'sink': function('tgs#sink_function'),
        \ }, get(g:, 'fzf_layout', {})))
  call fzf#run(l:wrapped)
endfunction

