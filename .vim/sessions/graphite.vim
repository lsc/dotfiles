" ~/Projects/dotfiles/vim/sessions/graphite.vim: Vim session script.
" Created by session.vim 1.4.17 on 18 June 2013 at 10:06:14.
" Open this file in Vim and run :source % to restore your session.

set guioptions=aegit
silent! set guifont=Terminus\ 10
if exists('g:syntax_on') != 1 | syntax on | endif
if exists('g:did_load_filetypes') != 1 | filetype on | endif
if exists('g:did_load_ftplugin') != 1 | filetype plugin on | endif
if exists('g:did_indent_on') != 1 | filetype indent on | endif
if &background != 'dark'
	set background=dark
endif
if !exists('g:colors_name') || g:colors_name != 'solarized' | colorscheme solarized | endif
call setqflist([{'lnum': 1, 'col': 0, 'valid': 1, 'vcol': 0, 'nr': -1, 'type': '', 'pattern': '', 'filename': 'zsh', 'text': ' command not found: ack'}])
let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Projects/puppet/env/test/modules/gdash
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +11 ~/Projects/charcoal/README.md
badd +26 ~/Projects/charcoal/config.yml.example
badd +66 ~/Projects/charcoal/config.yml
badd +11 ~/Projects/gdash/graph_templates/node_templates/collectd/cpu-average.graph
badd +1 ~/Projects/gdash/config/gdash.yaml-sample
badd +11 ~/Projects/gdash/config/gdash.yaml
badd +0 ~/Projects/charcoal/views/layout.haml
badd +10 ~/Projects/charcoal/views/stats.haml
badd +7 ~/Projects/charcoal/slug.rb
badd +7 ~/Projects/charcoal/charcoal.rb
badd +0 ~/Projects/gdash/graph_templates/dashboards/README.md
badd +3 ~/Projects/gdash/graph_templates/node_templates/collectd/dash.yaml
badd +13 ~/Projects/gdash/graph_templates/node_templates/Graphite/cpu-average.graph
badd +5 ~/Projects/gdash/graph_templates/node_templates/Graphite/dash.yaml
badd +1 ~/Projects/gdash/graph_templates/node_templates/collectd/cpu-max.graph
badd +1 ~/Projects/gdash/graph_templates/node_templates/collectd/disk-IO.graph
badd +5 ~/Projects/gdash/graph_templates/node_templates/collectd/memory-usage.graph
badd +8 ~/Projects/gdash/graph_templates/node_templates/Graphite/ws-consolidated.graph
badd +1 ~/Projects/gdash/sample/README.md
badd +30 ~/Projects/gdash/tools/dashboards-validation.rb
badd +46 ~/Projects/gdash/lib/gdash.rb
badd +0 manifests/init.pp
badd +10 manifests/config.pp
badd +4 ~/Projects/puppet/manifests/nodes/graphapp06.aza.se.pp
badd +0 zsh
badd +0 templates/gdash.yaml.erb
badd +0 templates/vhost.conf.erb
badd +1 ~/Projects/puppet/manifests/nodes/gsplacera01.aza.se.pp
badd +1 ~/Projects/puppet/manifests/nodes/ab01.aza.se.pp
badd +11 ~/Projects/puppet/env/test/modules/cq5-installer/manifests/init.pp
badd +1 ~/Projects/puppet/env/test/modules/apache/manifests/vhost.pp
badd +1 ~/Projects/puppet/manifests/nodes/ab02.aza.se.pp
badd +22 ~/Projects/puppet/env/prod/modules/testab-ws-cq/manifests/init.pp
badd +76 ~/Projects/graphene/example/dashboard.html
badd +1 ~/Projects/graphene/app/js/d3.gauge.js
badd +17 ~/Projects/graphene/app/js/graphene.coffee
badd +51 ~/Projects/graphene/example/dashboard-autodiscover.html
badd +1 ~/Projects/graphene/example/example-dash.js
badd +1 ~/Projects/graphene/build/index.js
badd +31 ~/Projects/graphene/build/index.css
badd +28 ~/Projects/graphene/tools/gencolors.rb
badd +49 ~/Projects/graphene/vendor/js/backbone.js
badd +1 ~/Projects/graphene/vendor/js/d3.js
badd +0 ~/Projects/graphene/vendor/js/underscore.js
badd +28 ~/Projects/puppet/manifests/nodes/kickstart.pp
badd +10 ~/Projects/puppet/env/prod/modules/users/manifests/init.pp
badd +1 ~/Projects/puppet/env/prod/modules/winbind/manifests/init.pp
badd +1 ~/Projects/puppet/env/prod/modules/winbind/manifests/install.pp
badd +1 ~/Projects/puppet/env/test/modules/avanza/manifests/init.pp
badd +0 ~/Projects/puppet/manifests/nodes/clusterapp02.aza.se.pp
silent! argdel *
set lines=80 columns=148
edit ~/Projects/gdash/config/gdash.yaml
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
2wincmd k
wincmd w
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 31 + 74) / 148)
exe '2resize ' . ((&lines * 24 + 40) / 80)
exe 'vert 2resize ' . ((&columns * 116 + 74) / 148)
exe '3resize ' . ((&lines * 24 + 40) / 80)
exe 'vert 3resize ' . ((&columns * 116 + 74) / 148)
exe '4resize ' . ((&lines * 28 + 40) / 80)
exe 'vert 4resize ' . ((&columns * 116 + 74) / 148)
argglobal
enew
" file NERD_tree_1
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
wincmd w
argglobal
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 22 - ((17 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
22
normal! 022l
wincmd w
argglobal
edit ~/Projects/gdash/graph_templates/node_templates/Graphite/ws-consolidated.graph
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 4 - ((3 * winheight(0) + 12) / 24)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
4
normal! 015l
wincmd w
argglobal
edit ~/Projects/gdash/graph_templates/node_templates/Graphite/dash.yaml
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 5 - ((3 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 04l
wincmd w
exe 'vert 1resize ' . ((&columns * 31 + 74) / 148)
exe '2resize ' . ((&lines * 24 + 40) / 80)
exe 'vert 2resize ' . ((&columns * 116 + 74) / 148)
exe '3resize ' . ((&lines * 24 + 40) / 80)
exe 'vert 3resize ' . ((&columns * 116 + 74) / 148)
exe '4resize ' . ((&lines * 28 + 40) / 80)
exe 'vert 4resize ' . ((&columns * 116 + 74) / 148)
tabedit templates/gdash.yaml.erb
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
3wincmd k
wincmd w
wincmd w
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 31 + 74) / 148)
exe '2resize ' . ((&lines * 0 + 40) / 80)
exe 'vert 2resize ' . ((&columns * 116 + 74) / 148)
exe '3resize ' . ((&lines * 0 + 40) / 80)
exe 'vert 3resize ' . ((&columns * 116 + 74) / 148)
exe '4resize ' . ((&lines * 75 + 40) / 80)
exe 'vert 4resize ' . ((&columns * 116 + 74) / 148)
exe '5resize ' . ((&lines * 0 + 40) / 80)
exe 'vert 5resize ' . ((&columns * 116 + 74) / 148)
argglobal
enew
" file NERD_tree_2
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
wincmd w
argglobal
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 17 - ((16 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
17
normal! 017l
wincmd w
argglobal
edit manifests/init.pp
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 17 - ((16 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
17
normal! 0
wincmd w
argglobal
edit manifests/config.pp
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 21 - ((20 * winheight(0) + 37) / 75)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
21
normal! 0
wincmd w
argglobal
edit templates/vhost.conf.erb
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 14 - ((13 * winheight(0) + 0) / 0)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
14
normal! 020l
wincmd w
exe 'vert 1resize ' . ((&columns * 31 + 74) / 148)
exe '2resize ' . ((&lines * 0 + 40) / 80)
exe 'vert 2resize ' . ((&columns * 116 + 74) / 148)
exe '3resize ' . ((&lines * 0 + 40) / 80)
exe 'vert 3resize ' . ((&columns * 116 + 74) / 148)
exe '4resize ' . ((&lines * 75 + 40) / 80)
exe 'vert 4resize ' . ((&columns * 116 + 74) / 148)
exe '5resize ' . ((&lines * 0 + 40) / 80)
exe 'vert 5resize ' . ((&columns * 116 + 74) / 148)
tabedit ~/Projects/puppet/manifests/nodes/clusterapp02.aza.se.pp
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winheight=1 winwidth=1
exe 'vert 1resize ' . ((&columns * 31 + 74) / 148)
exe 'vert 2resize ' . ((&columns * 116 + 74) / 148)
argglobal
enew
" file NERD_tree_8
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
wincmd w
argglobal
setlocal fdm=syntax
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 5 - ((4 * winheight(0) + 39) / 78)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
5
normal! 0
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 31 + 74) / 148)
exe 'vert 2resize ' . ((&columns * 116 + 74) / 148)
tabnext 3
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
NERDTree ~/Projects/gdash
execute "bwipeout" s:bufnr
1resize 78|vert 1resize 31|2resize 24|vert 2resize 116|3resize 24|vert 3resize 116|4resize 28|vert 4resize 116|
tabnext 2
1wincmd w
let s:bufnr = bufnr("%")
NERDTree ~/Projects/puppet/env/test/modules/gdash
execute "bwipeout" s:bufnr
1resize 78|vert 1resize 31|2resize 1|vert 2resize 116|3resize 1|vert 3resize 116|4resize 72|vert 4resize 116|5resize 1|vert 5resize 116|
tabnext 3
1wincmd w
let s:bufnr = bufnr("%")
NERDTree ~/Projects/puppet
execute "bwipeout" s:bufnr
1resize 78|vert 1resize 31|2resize 78|vert 2resize 116|
tabnext 3
2wincmd w

" vim: ft=vim ro nowrap smc=128
