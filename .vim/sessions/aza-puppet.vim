" ~/Projects/dotfiles/vim/sessions/aza-puppet.vim: Vim session script.
" Created by session.vim 1.5.2 on 25 April 2013 at 13:54:29.
" Open this file in Vim and run :source % to restore your session.

set guioptions=aegit
silent! set guifont=Monospace\ 9
if exists('g:syntax_on') != 1 | syntax on | endif
if exists('g:did_load_filetypes') != 1 | filetype on | endif
if exists('g:did_load_ftplugin') != 1 | filetype plugin on | endif
if exists('g:did_indent_on') != 1 | filetype indent on | endif
if &background != 'dark'
	set background=dark
endif
if !exists('g:colors_name') || g:colors_name != 'desert' | colorscheme desert | endif
call setqflist([])
let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Projects/puppet
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +23 manifests/nodes/jira01.aza.se.pp
badd +22 env/test/modules/jira/manifests/service.pp
badd +27 env/prod/modules/jira/manifests/service.pp
badd +1 auth.conf
badd +2 manifests/nodes/gsci01.test.aza.se.pp
badd +1 env/test/modules/mysql/templates/mysqlbackup.sh.erb
badd +19 env/test/modules/mysql/manifests/server.pp
badd +91 env/test/modules/mysql/manifests/params.pp
badd +25 env/test/modules/mysql/manifests/db.pp
badd +40 env/test/modules/mysql/manifests/server/config.pp
badd +78 env/test/modules/mysql/manifests/config.pp
badd +38 manifests/nodes/devkv01.test.aza.se.pp
badd +37 manifests/nodes/devkv02.test.aza.se.pp
badd +47 manifests/nodes/devtr01.test.aza.se.pp
badd +3 env/test/modules/jira/manifests/init.pp
badd +1 env/prod/modules/activemq/manifests/init.pp
badd +1 env/prod/modules/apache-svn/manifests/files.pp
badd +1 env/prod/modules/apache-svn/manifests/config/vhost.pp
badd +105 env/test/modules/mysql/README.md
badd +15 env/test/modules/jira/manifests/config.pp
badd +3 env/test/modules/jira/manifests/install.pp
badd +7 env/test/modules/jira/manifests/params.pp
badd +1 env/test/modules/mysql/manifests/init.pp
badd +19 env/test/modules/jira/Vagrantfile
badd +1 env/test/modules/login_status/manifests/init.pp
badd +3 env/test/modules/login_status/files/avanzabank-logintest
badd +51 env/test/modules/login_status/files/check_login.py
badd +1 env/test/modules/login_status/files/logintest.py
badd +20 env/test/modules/login_status/files/iphone_logintest.py
badd +7 env/test/modules/login_status/README
badd +1 env/test/modules/pymodules/README
badd +2 env/test/modules/pymodules/files/pygraphite.py
badd +16 env/test/modules/pymodules/files/pyhobbit.py
badd +71 env/test/modules/pymodules/files/pyserverstatus.py
badd +2 mini_logintest.py
badd +116 ~/.vimrc
silent! argdel *
set lines=75 columns=228
edit env/test/modules/jira/manifests/params.pp
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 37 + 114) / 228)
exe '2resize ' . ((&lines * 35 + 37) / 75)
exe 'vert 2resize ' . ((&columns * 83 + 114) / 228)
exe '3resize ' . ((&lines * 37 + 37) / 75)
exe 'vert 3resize ' . ((&columns * 83 + 114) / 228)
exe '4resize ' . ((&lines * 62 + 37) / 75)
exe 'vert 4resize ' . ((&columns * 106 + 114) / 228)
exe '5resize ' . ((&lines * 10 + 37) / 75)
exe 'vert 5resize ' . ((&columns * 106 + 114) / 228)
" argglobal
enew
" file NERD_tree_1
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal nofen
wincmd w
" argglobal
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 7 - ((6 * winheight(0) + 17) / 35)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
7
normal! 0
wincmd w
" argglobal
edit env/test/modules/jira/manifests/config.pp
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 15 - ((14 * winheight(0) + 18) / 37)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
15
normal! 05l
wincmd w
" argglobal
edit env/test/modules/jira/manifests/service.pp
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 35 - ((34 * winheight(0) + 31) / 62)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
35
normal! 0
wincmd w
" argglobal
enew
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
wincmd w
4wincmd w
exe 'vert 1resize ' . ((&columns * 37 + 114) / 228)
exe '2resize ' . ((&lines * 35 + 37) / 75)
exe 'vert 2resize ' . ((&columns * 83 + 114) / 228)
exe '3resize ' . ((&lines * 37 + 37) / 75)
exe 'vert 3resize ' . ((&columns * 83 + 114) / 228)
exe '4resize ' . ((&lines * 62 + 37) / 75)
exe 'vert 4resize ' . ((&columns * 106 + 114) / 228)
exe '5resize ' . ((&lines * 10 + 37) / 75)
exe 'vert 5resize ' . ((&columns * 106 + 114) / 228)
tabnext 1
if exists('s:wipebuf')
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
tabnext 1
1wincmd w
let s:bufnr = bufnr("%")
NERDTree ~/Projects/puppet/env/test/modules/jira
execute "bwipeout" s:bufnr
tabnext 1
5wincmd w
let s:bufnr = bufnr("%")
cwindow
execute "bwipeout" s:bufnr
1resize 73|vert 1resize 37|2resize 35|vert 2resize 83|3resize 37|vert 3resize 83|4resize 62|vert 4resize 106|5resize 10|vert 5resize 106|
tabnext 1
4wincmd w

" vim: ft=vim ro nowrap smc=128
