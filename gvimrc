:set guifont=Inconsolata\ 10
:colorscheme wombat 
:set guioptions-=T
:set guioptions-=m

if has ("gui_macvim")
	" Fullscreen takes the whole screen"
	set fuoptions=maxhorz,maxvert
	" Command-T plugin bound to Command-T
	macmenu &File.New\ Tab key=<nop>
	map <D-t> :CommandT<CR>
	map <D-e> :call StartTerm()<CR>
endif



