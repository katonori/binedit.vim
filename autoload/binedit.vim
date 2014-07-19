" Copyright (c) 2013, katonori(katonori.d@gmail.com) All rights reserved.
" 
" Redistribution and use in source and binary forms, with or without modification, are
" permitted provided that the following conditions are met:
" 
"   1. Redistributions of source code must retain the above copyright notice, this list
"      of conditions and the following disclaimer.
"   2. Redistributions in binary form must reproduce the above copyright notice, this
"      list of conditions and the following disclaimer in the documentation and/or other
"      materials provided with the distribution.
"   3. Neither the name of the katonori nor the names of its contributors may be used to
"      endorse or promote products derived from this software without specific prior
"      written permission.
" 
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
" EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
" OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
" SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
" INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
" TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
" BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
" CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
" ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
" DAMAGE.
let s:XXDCmdColNum = 16
let s:XXDCmd = 'xxd -g1 -c ' . s:XXDCmdColNum
let s:line = 0
let s:column = 0

"
" refresh buffer
"
function! binedit#Refresh()
    call s:DeBinarizeBuf()
    call s:BinarizeBuf()
    call cursor(s:line, s:column)
endfunction

"
" begin binary eiditing
"
function! binedit#BeginEdit()
    let l:fileName = expand("%:p")
    let l:tmpFileName = tempname()
    " setup the buffer content
    exec "w! " . l:tmpFileName
    exec "e! " . l:tmpFileName
    setlocal fenc=""
    setlocal filetype=xxd
    setlocal binary
    setlocal noeol
    call s:BinarizeBuf()
    exec "w"
    " keep original filename
    let b:origFileName = l:fileName
    exec "setlocal statusline=[original\\ file:\\ " . l:fileName . "]\\ " . escape(&statusline, ' ')
    call s:Setup()
endfunction

"
" commit the content of buffer to the original file
"
function! binedit#Commit()
    call s:DeBinarizeBuf() 
    let l:lines = getline(0, line("$"))
    call writefile(l:lines, b:origFileName, "b")
    call s:BinarizeBuf() 
    call cursor(s:line, s:column)
endfunction

"
" convert the buffer content hex to text
"
function! s:BinarizeBuf()
    setlocal binary
    setlocal noeol
    silent exec '%!' . s:XXDCmd
endfunction

"
" convert the buffer content text to hex
"
function! s:DeBinarizeBuf()
    let s:line = line(".")
    let s:column = col(".")
    silent exec ':%s/.\{' . s:XXDCmdColNum . '}$//'
    silent exec ':%s/^[0-9a-f]\+://'
    silent exec ':%s/\s//g'
    silent exec '%!xxd -r -p'
endfunction

"
" setup map and autocmd
"
function! s:Setup()
    nnoremap <buffer> <silent> <leader>r :BinEditRefresh<CR>
    nnoremap <buffer> <silent> <leader>c :BinEditCommit<CR>

    autocmd!
    autocmd! BufWritePost <buffer> exec ":BinEditRefresh" | if g:BinEditAutoCommit != 0 | exec ":BinEditCommit" | endif
endfunction
