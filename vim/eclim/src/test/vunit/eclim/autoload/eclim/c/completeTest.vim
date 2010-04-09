" Author:  Eric Van Dewoestine
"
" Description: {{{
"   Test case for complete.vim
"
" License:
"
" Copyright (C) 2005 - 2009  Eric Van Dewoestine
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.
"
" }}}

" SetUp() {{{
function! SetUp()
  exec 'cd ' . g:TestEclimWorkspace . 'eclim_unit_test_c'
endfunction " }}}

" TestComplete() {{{
function! TestComplete()
  edit! src/test_complete_vunit.c
  call PeekRedir()

  call cursor(11, 6)
  let start = eclim#c#complete#CodeComplete(1, '')
  call VUAssertEquals(5, start, 'Wrong starting column.')

  let results = eclim#c#complete#CodeComplete(0, '')
  call PeekRedir()
  echo 'results = ' . string(results)
  call VUAssertEquals(len(results), 2, 'Wrong number of results.')
  call VUAssertEquals('test_a', results[0].word, 'Wrong result.')
  call VUAssertEquals('test_b', results[1].word, 'Wrong result.')

  call cursor(12, 15)
  let start = eclim#c#complete#CodeComplete(1, '')
  call VUAssertEquals(9, start, 'Wrong starting column.')

  let results = eclim#c#complete#CodeComplete(0, '')
  call PeekRedir()
  echo 'results = ' . string(results)
  call VUAssertEquals(len(results), 2, 'Wrong number of results.')
  call VUAssertEquals('EXIT_FAILURE', results[0].word, 'Wrong result.')
  call VUAssertEquals('EXIT_SUCCESS', results[1].word, 'Wrong result.')
endfunction " }}}

" vim:ft=vim:fdm=marker
