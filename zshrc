stty erase '^?'
export LANGUAGE=en_GB
export LC_ALL=en_GB.UTF-8
export LANG=en_GB
export PATH="$PATH:/home/lsc/bin:/opt/android-sdk-1.5/tools:/var/lib/gems/1.9.1/bin/"
export GDK_USE_XFT=1
export HOSTTYPE="$(uname -m)"
export COLORTERM=yes
export LINKS_XTERM=screen
export MAILDIR=$HOME/.mail/
export EDITOR="/usr/bin/vim"
export JAVA_HOME=/usr/lib/jvm/sun-jdk6
export WTK_HOME='/home/lsc/lib/wtk2.5.2'
export GEDITOR="$(which gvim)"
alias ls='ls -F --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lal='ls -al'
alias xen='sshfs 10.0.0.2:/home/lsc ~/tmp'

[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS) 
autoload -U colors zsh/terminfo
colors

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval $color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval ${(L)color}='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
done

export NC=$'%{[0m%}' 
# Follow GNU LS_COLORS
zmodload -i zsh/complist
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*' list-colors '=%*=01;31'

# Load the super-duper completion stuff
autoload -U compinit; compinit

# Very powerful version of mv implemented in zsh, of which I know very
# little.
#
# Read /path_to_zsh_functions/zmv for some basic examples.
autoload -z zmv

# Very nice command line calculator written in zsh.
autoload -z zcalc

# Like xargs, but instead of reading lines of arguments from standard input,
# it takes them from the command line. This is possible/useful because,
# especially with recursive glob operators, zsh often can construct a command
# line for a shell function that is longer than can be accepted by an external
# command. This is what's often referred to as the "shitty Linux exec limit" ;)
# The limitation is on the number of characters or arguments.
# 
# slarti@pohl % echo {1..30000}
# zsh: argument list too long: /bin/echo
# zsh: exit 127   /bin/echo {1..30000}
autoload -z zargs

# Yes, we are as bloated as emacs

# zed is a tiny command-line editor in pure ZSH; no other shell could do this.
# zed itself is simple as anything, but it's killer feature for me is that it
# can edit functions on the go with zed -f <funcname>. Some people argue ZSH's
# bloatedness is a liability - I disagree. zed, zmv, and zftp are LIFESAVERS.
autoload -z zed

# Incremental completion of a word. After starting this, a list of
# completion choices can be shown after every character you type, which
# can deleted with ^H or delete. Return will accept the current
# completion. Hit tab for normal completion, ^G to get back where you
# came from and ^D to list matches.
autoload -U incremental-complete-word
zle -N incremental-complete-word
bindkey "^Xi" incremental-complete-word

# This function allows you type a file pattern, and see the results of
# the expansion at each step.  When you hit return, they will be
# inserted into the command line.
autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files

# This set of functions implements a sort of magic history searching.
# After predict-on, typing characters causes the editor to look backward
# in the history for the first line beginning with what you have typed so
# far.  After predict-off, editing returns to normal for the line found.
# In fact, you often don't even need to use predict-off, because if the
# line doesn't match something in the history, adding a key performs
# standard completion - though editing in the middle is liable to delete
# the rest of the line.
autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey "^X^Z" predict-on
bindkey "^Z" predict-off

# run-help is a clever little help finder, bound in ZLE to Esc-h
#autoload -U run-help

# Colors
autoload -U colors; colors

PROMPT="\$purple\$?\$NC|\$white%n\$green %m >\$white>\$NC "
RPROMPT="\$cyan%~\$NC"

# Man pages look a hell of a lot better in vim.

# SCREENDIR will screw screen up
unset SCREENDIR

# Completion
compctl -b bindkey
compctl -v export
compctl -o setopt
compctl -v unset
compctl -o unsetopt
compctl -v vared
compctl -c which
compctl -c sudo

# History things
HISTFILE=$HOME/.zshist
SAVEHIST=1000
HISTSIZE=1600
TMPPREFIX=$HOME/tmp

# Key bindings.. looking healthier now.

# You can use:
# % autoload -U zkbd
# % zkbd
# to discover your keys.

# Emacs keybindings. I know that makes me a weirdo, especially as I like vim,
# but vi keybindings aren't that useful in a shell. Emacs is actually quite
# good for line editing.
bindkey -e

# Up, down left, right.
#
# echotc is part of the zsh/termcap module. It outputs the termcap value
# corresponding to the capability it was given as an argument. man zshmodules.
zmodload -i zsh/termcap
bindkey "$(echotc kl)" backward-char
bindkey "$(echotc kr)" forward-char
bindkey "$(echotc ku)" up-line-or-history
bindkey "$(echotc kd)" down-line-or-history

# FIXME: Get the others on that keypad bound too
# Aliases
LSCOLORS="exfxexdxbxegedadabagaead"
export LSCOLORS


# Sexy completion stuff from oberyno
_category() {
    categories=(/usr/portage/metadata/cache/*-*)
    category=${(M)${${categories##*/}}}
    _tags -s category && { compadd "$@" ${(kv=category} }
}

google() {
    w3m "http://www.google.com/search?q=$@"
}

# Pretty menu!
zstyle ':completion:*' menu select=1

# Completion options
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands
zstyle ':completion::complete:*' '\'

# Use menuselection for pid completion
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

#  tag-order 'globbed-files directories' all-files 
zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# With commands like rm, it's annoying if you keep getting offered the same
# file multiple times. This fixes it. Also good for cp, et cetera..
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
 
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# Simulate spider's old abbrev-expand 3.0.5 patch 
zstyle ':completion:*:history-words' stop verbose
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false

# zsh Options. Big long lovely way of setting them.
setopt                       \
     NO_all_export           \
        always_last_prompt   \
        always_to_end        \
        append_history       \
        auto_cd              \
        auto_list            \
        auto_menu            \
        auto_name_dirs       \
        auto_param_keys      \
        auto_param_slash     \
        auto_pushd           \
        auto_remove_slash    \
     NO_auto_resume          \
        bad_pattern          \
        bang_hist            \
     NO_beep                 \
        brace_ccl            \
        correct_all          \
     NO_bsd_echo             \
        cdable_vars          \
     NO_chase_links          \
        clobber              \
        complete_aliases     \
        complete_in_word     \
        correct              \
     NO_correct_all          \
        csh_junkie_history   \
     NO_csh_junkie_loops     \
     NO_csh_junkie_quotes    \
     NO_csh_null_glob        \
        equals               \
        extended_glob        \
        extended_history     \
        function_argzero     \
        glob                 \
     NO_glob_assign          \
        glob_complete        \
     NO_glob_dots            \
     NO_glob_subst           \
     NO_hash_cmds            \
     NO_hash_dirs            \
        hash_list_all        \
        hist_allow_clobber   \
        hist_beep            \
        hist_ignore_dups     \
        hist_ignore_space    \
     NO_hist_no_store        \
        hist_verify          \
     NO_hup                  \
     NO_ignore_braces        \
     NO_ignore_eof           \
        interactive_comments \
        inc_append_history   \
     NO_list_ambiguous       \
     NO_list_beep            \
        list_types           \
        long_list_jobs       \
        magic_equal_subst    \
     NO_mail_warning         \
     NO_mark_dirs            \
        menu_complete        \
        multios              \
        nomatch              \
        notify               \
     NO_null_glob            \
        numeric_glob_sort    \
     NO_overstrike           \
        path_dirs            \
        posix_builtins       \
     NO_print_exit_value     \
     NO_prompt_cr            \
        prompt_subst         \
        pushd_ignore_dups    \
     NO_pushd_minus          \
        pushd_silent         \
        pushd_to_home        \
        rc_expand_param      \
     NO_rc_quotes            \
     NO_rm_star_silent       \
     NO_sh_file_expansion    \
        sh_option_letters    \
        short_loops          \
     NO_sh_word_split        \
     NO_single_line_zle      \
     NO_sun_keyboard_hack    \
     NO_verbose              \
        zle

# Last but not least...
#Rebind HOME and END to do the decent thing:                                    
bindkey '^[[7~' beginning-of-line                                                
bindkey '^[[8~' end-of-line                                                      
case $TERM in (xterm*)                                                          
        bindkey '\eOH' beginning-of-line                                        
        bindkey '\eOF' end-of-line                                              
esac                                                                            
                                                                                
#To discover what keycode is being sent, hit ^v                                 
#and then the key you want to test.                                             
                                                                                
#And DEL too, as well as PGDN and insert:                                       
bindkey '^[[3~' delete-char                                                     
bindkey '^[[6~' end-of-history                                                  
#bindkey '\e[2~' redisplay                                                      
                                                                                
#Now bind pgup to paste the last word of the last command,                      
bindkey '^[[5~' insert-last-word  

# Some functions used to modify RPROMPT when we're in a Git or SVN repo
# git functions mostly stolen from kalasjocke
function parse_git_dirty {
  git diff --quiet 2> /dev/null || echo ' ⚡'
}
 
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/($yellow\1$red$(parse_git_dirty)$NC) /"
}
 
# Custom RPROMPT for Git and SVN repos.
function precmd() {
  git_branch=$(parse_git_branch)
  export RPROMPT="%2~ ${git_branch}${svn_branch}"
}

