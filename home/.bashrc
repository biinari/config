# ~/.bashrc

if [ -f "$HOME/.bash_profile" ]; then
    if [ -z "$_BASHRC" ]; then
        export _BASHRC=1
        . "$HOME/.bash_profile"
    fi
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # Colour support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429).
    color_prompt=yes
else
    color_prompt=
fi

if [ -n "$DESKTOP_SESSION" ]; then
    user_host='\u'
else
    user_host='\u@\h'
fi

if [ "$color_prompt" = yes ]; then
    PS1="\[\033[01;32m\]${user_host}\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[01;36m\]\$(__git_ps1 ' %s')\[\033[00m\]\$ "
else
    PS1="${user_host}:\W\$(__git_ps1 ' %s')\$ "
fi
unset color_prompt user_host

# Git PS1
export GIT_PS1_SHOWUPSTREAM="auto"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
grep_excludes='--exclude=".*.swp" --exclude-dir=.svn --exclude-dir=.git --exclude-dir=templates_c --exclude-dir=min --exclude=tags --exclude-dir=vendor --exclude=debug.log --exclude=blog-deleted.php --exclude-dir=cache'
alias grep="grep -I ${grep_excludes}"
alias fgrep="fgrep -I ${grep_excludes}"
alias egrep="egrep -I ${grep_excludes}"
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    [ -e "$HOME/.dir_colors" ] && DIR_COLORS="$HOME/.dir_colors"
    [ -e "$DIR_COLORS" ] || DIR_COLORS=""
    eval "`dircolors -b $DIR_COLORS`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias grep="grep -I --color=auto ${grep_excludes}"
    alias fgrep="fgrep -I --color=auto ${grep_excludes}"
    alias egrep="egrep -I --color=auto ${grep_excludes}"
fi
unset grep_excludes

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias lsp='ls --color=no -p'

# Make less search case-insensitive
alias less="less -i"

alias svndiffw="svn diff --diff-cmd=diff -x -uw"
alias svngvimdiff="svn diff --diff-cmd=svnvimdiffwrap"
#alias svndiffu="svn diff --diff-cmd=diff -x -u"
alias svnwdiff="svn diff --diff-cmd=wdiffwrap -x -t"
alias svnwdiffless="svn diff --diff-cmd=wdiffwrap -x -a"
alias svnst='svn st | grep -v "^?.*\(cache\/\|resources\/\)"'

alias sshelancs="ssh elancs"

# fatsoma connection
alias sshgate='ssh gate'
alias sshdev="ssh gate -t cloud dev"
alias sshplatform="ssh gate -t cloud platform"

alias svnmergecoda='svn merge ^/platform/trunk/projects/coda/coda ; svn revert --recursive lib/model/interface/'
alias svnmergesplit='svn merge ^/platform/trunk/platform platform ; svn merge ^/platform/trunk/projects/coda/coda projects/coda/coda ; svn merge ^/platform/trunk/projects/coda/codapreview projects/coda/codapreview ; svn merge ^/platform/trunk/config.php config.php ; svn merge ^/platform/trunk/index.php index.php'
alias svnmergesplitcoda='svn merge ^/platform/branches/split/projects/coda/coda'

alias gitvimdiff="GIT_PAGER= GIT_EXTERNAL_DIFF=gitvimdiffwrap git diff"

alias grepplatform="grep -I --color=auto --exclude='*.svn-base' --exclude='*.swp' --exclude-dir='codapreview' --exclude-dir='.svn'"
alias sedgrepfile="sed 's/^\([^:]*\):.*$/\1/' | sort | uniq"

alias findlarge='du -shx .* * --exclude="." --exclude=".." | grep "^[0-9.]*[MG]"'

alias find_wcount='find . -path \*.svn\* -prune -o \( -name \*.php -o -name \*.css -o -name \*.sass -o -name \*.js -o -name \*.cs -o -name \*.coffee \) -type f -print'
alias wcrl='wc -l `find_wcount`'
alias wcrc='wc -c `find_wcount`'
alias wcrw='wc -w `find_wcount`'

alias jslint='jsl -nologo -nofilelisting -nosummary -nocontext -conf /etc/jsl.conf -process '
alias jslintr='find . -name "*.js" -exec jsl -nologo -nofilelisting -nosummary -nocontext -conf /etc/jsl.conf -process \{\} \;'

function csslint_error () {
    /usr/bin/csslint --quiet --format=compact $@ | grep -v "\(Warning\|Is the file empty\|^$\)"
}
alias csslintr='find . -name "*.css" -exec csslint --quiet --format=compact \{\} \; | grep -v "\(Warning\|Is the file empty\|^$\)"'

alias phplintr='find . -name "*.php" -exec php -n -l "{}" \; | grep -v "^No syntax errors detected in"'

if [ -f /usr/share/dict/words ]; then
    alias apg='apg -a1 -m5 -x10 -n1 -MNCL -r/usr/share/dict/words'
else
    alias apg='apg -a1 -m5 -x10 -n1 -MNCL'
fi

alias rdpcoda="xfreerdp -u 'codaagency\fatsoma' -p '!f4ts0m4!' remote.codaagency.com"

alias pacman='pacman-color'

alias dual_monitor="xrandr --output HDMI1 --right-of LVDS1 --auto"
alias single_monitor="xrandr --output HDMI1 --off"

man () {
    # mb - begin blinking
    # md - begin bold
    # me - end mode
    # se - end standout-mode
    # so - begin standout-mode - info box
    # ue - end underline
    # us - begin underline
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;31m") \
        LESS_TERMCAP_md=$(printf "\e[1;38;5;74m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[38;5;246m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[4;37m") \
            man "$@"
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

[ -f $HOME/git/rails_completion/rails.bash ] && . $HOME/git/rails_completion/rails.bash

[ -r /usr/share/git/git-prompt.sh ] && . /usr/share/git/git-prompt.sh
