" Vim syntax file
" Language:	TCL/f5 Networks iRule
" Modified tcl.vim by Matt Cauthorn for f5 Networks.

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif
" Source the tcl syntax file.
so $VIMRUNTIME/syntax/tcl.vim

"
" Our keywords below
syn keyword iRuleKeyword 'contains' ends_with equals matches matches_regex starts_with and not or
syn keyword iRuleKeyword accumulate active_members active_nodes b64decode b64encode cache client_addr
syn keyword iRuleKeyword client_port clientside clone cpu crc32 decode_uri discard domain drop event findclass findstr forward
syn keyword iRuleKeyword getfield htonl htons imid ip_protocol ip_tos ip_ttl LINE link_qos listen local_addr log 
syn keyword iRuleKeyword matchclass md5 node ntohl ntohs peer persist pool
syn keyword iRuleKeyword priority rateclass redirect reject relate_client relate_server remote_addr rmd160 server_addr
syn keyword iRuleKeyword server_port serverside session sha1 sha256 sha384 sha512 snat snatpool substr timing use
syn keyword iRuleKeyword virtual vlan_id when wideip when findstr pool server_port ttl reject crc32 forward
syn keyword iRuleKeyword host noerror discard log substr client_port cname drop active_members whereis


" Now match all of our '::' commands.
" Try to match all of the events here.
"
" MC - Pick up here! It's not matching the ::
syn match iRuleCommand "[A-Z]\+_\{1}[A-Z]\+"
syn match iRuleCommand "$\(\(::\)\?\([[:alnum:]_.]*::\)*\)\a[a-zA-Z0-9_.]*"

""syn match iRuleCommand "[A-Z0-9]\+\:\{2}[a-zA-Z]\+"
"syn match iRuleCommand "[A-Z0-9]+\:\{2}[a-zA-Z]+"
""syn match iRuleCommand "[a-zA-Z0-9_]*::[a-zA-Z0-9_]*"
syn match iRuleBracket "[{}\[\]()]"
syn match iRuleComment "#.*$"

"
" End of our stuff
"
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_tcl_syntax_inits")
  if version < 508
    let did_tcl_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  highlight link iRuleKeyword   Statement
  highlight link iRuleCommand   Macro
  highlight link iRuleBracket   Typedef
  highlight link iRuleComment   Comment
  
  delcommand HiLink
endif

let b:current_syntax = "irul"

" vim: ts=8
