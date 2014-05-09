if has('gui_macvim') 
	:set guifont=Monaco:h12
elseif has('gui_win32')
	:set guifont=Inconsolata:h12
else 
	:set guifont=Inconsolata\ 10
endif 

:colorscheme desert
:set guioptions-=T
:set guioptions-=m
:set guioptions+=LlRrb
:set guioptions-=LlRrb
