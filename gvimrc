if has('gui_macvim') 
	:set guifont=Inconsolata:h14
elseif has('gui_win32')
	:set guifont=Inconsolata:h12
else 
	:set guifont=Terminus\ 8
endif 

:colorscheme BlackSea
:set guioptions-=T
:set guioptions-=m
:set guioptions+=LlRrb
:set guioptions-=LlRrb
