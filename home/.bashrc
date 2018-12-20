#!/bin/bash
# ~/.bashrc

if [ -f "$HOME/.bash_profile" ]; then
    if [ -z "$_BASHRC" ]; then
        export _BASHRC=1
        # shellcheck disable=1090
        . "$HOME/.bash_profile"
    fi
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth
alias history_null='export HISTFILE=/dev/null'

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
    title_user_host="${USER}"
else
    user_host='\u@\h'
    title_user_host="${USER}@${HOSTNAME}"
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\033[01;32m\]'${user_host}'\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[01;36m\]$(__git_ps1 " %s")\[\033[00m\]$ '
else
    PS1='${user_host}:\W$(__git_ps1 " %s")$ '
fi
unset color_prompt user_host

# Git PS1
export GIT_PS1_SHOWUPSTREAM="auto"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    #PROMPT_COMMAND='echo -ne "\033]0;${title_user_host}: ${PWD/#$HOME/\~}\007"'
    PROMPT_COMMAND='echo -ne "\033]0;${title_user_host}: $([ "$PWD" = "$HOME" ] && echo \~ || basename "$PWD")\007"'
    export ORIG_PROMPT_COMMAND="$PROMPT_COMMAND"
    ;;
*)
    ;;
esac
title() {
    if [ $# -gt 0 ]; then
        PROMPT_COMMAND="echo -ne \"\\033]0;$* : \${PWD/\$HOME/\\~}\\007\""
    else
        PROMPT_COMMAND="$ORIG_PROMPT_COMMAND"
    fi
}

# enable color support of ls and also add handy aliases
grep_excludes='--exclude=".*.swp" --exclude-dir=.svn --exclude-dir=.git --exclude-dir=templates_c --exclude-dir=min --exclude=tags --exclude-dir=vendor --exclude-dir=.bundle --exclude=debug.log --exclude=blog-deleted.php --exclude-dir=blog --exclude-dir=log --exclude-dir=request_cache --exclude-dir=saved_pages --exclude-dir=coverage --exclude-dir=Godeps --exclude-dir=.terraform --exclude-dir="build" --exclude-dir=".idea" --exclude-dir=.kitchen'
# shellcheck disable=SC2139
alias grep="grep -I ${grep_excludes}"
# shellcheck disable=SC2139
alias fgrep="fgrep -I ${grep_excludes}"
# shellcheck disable=SC2139
alias egrep="egrep -I ${grep_excludes}"
# shellcheck disable=SC2139
alias grepui="grep -I ${grep_excludes} --exclude-dir=public --exclude-dir=tmp"
# shellcheck disable=SC2139
alias greps="grep -I ${grep_excludes} --exclude-dir=spec --exclude='*_test.go'"
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    [ -e "$HOME/.dir_colors" ] && DIR_COLORS="$HOME/.dir_colors"
    [ -e "$DIR_COLORS" ] || DIR_COLORS=""
    eval "$(dircolors -b $DIR_COLORS)"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    # shellcheck disable=SC2139
    alias grep="grep -I --color=auto ${grep_excludes}"
    # shellcheck disable=SC2139
    alias fgrep="fgrep -I --color=auto ${grep_excludes}"
    # shellcheck disable=SC2139
    alias egrep="egrep -I --color=auto ${grep_excludes}"
    # shellcheck disable=SC2139
    alias grepui="grep -I --color=auto ${grep_excludes} --exclude-dir=public --exclude-dir=tmp"
fi
unset grep_excludes

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias lsp='ls --color=no -p'

# Make less search case-insensitive and understand escape codes
alias less="less -i -R"

alias svndiffw="svn diff --diff-cmd=diff -x -uw"
alias svngvimdiff="svn diff --diff-cmd=svnvimdiffwrap"
#alias svndiffu="svn diff --diff-cmd=diff -x -u"
alias svnwdiff="svn diff --diff-cmd=wdiffwrap -x -t"
alias svnwdiffless="svn diff --diff-cmd=wdiffwrap -x -a"
alias svnst='svn st | grep -v "^?.*\(cache\/\|resources\/\)"'

alias svnmergecoda='svn merge ^/platform/trunk/projects/coda/coda ; svn revert --recursive lib/model/interface/'
alias svnmergesplit='svn merge ^/platform/trunk/platform platform ; svn merge ^/platform/trunk/projects/coda/coda projects/coda/coda ; svn merge ^/platform/trunk/projects/coda/codapreview projects/coda/codapreview ; svn merge ^/platform/trunk/config.php config.php ; svn merge ^/platform/trunk/index.php index.php'
alias svnmergesplitcoda='svn merge ^/platform/branches/split/projects/coda/coda'

alias gitvimdiff="GIT_PAGER= GIT_EXTERNAL_DIFF=gitvimdiffwrap git diff"

alias grepplatform="grep -I --color=auto --exclude='*.svn-base' --exclude='*.swp' --exclude-dir='codapreview' --exclude-dir='.svn'"
alias sedgrepfile="sed 's/^\\([^:]*\\):.*\$/\\1/' | sort -u"

alias findlarge='du -shx .* * --exclude="." --exclude=".." | grep "^[0-9.]*[MG]"'

alias find_wcount='find . -path \*.svn\* -prune -o -path \*.git\* -prune -o -regex ".*\.\(php\|css\|s[ac]ss\|js\|cs\|coffee\|rb\|rake\|py\|sh\)" -type f'
alias wcrl='find_wcount -exec wc -l \{\} \+'
alias wcrc='find_wcount -exec wc -c \{\} \+'
alias wcrw='find_wcount -exec wc -w \{\} \+'

alias jslint='jsl -nologo -nofilelisting -nosummary -nocontext -conf /etc/jsl.conf -process '
alias jslintr='find . -name "*.js" -not -name "*.min.*" -not -path "*/vendor/*" -exec jsl -nologo -nofilelisting -nosummary -nocontext -conf /etc/jsl.conf -process \{\} \;'

csslint_ignores='--ignore=adjoining-classes,overqualified-elements,ids,qualified-headings,unique-headings'
csslint_error() {
    # shellcheck disable=SC2048 disable=2086
    /usr/bin/csslint --quiet --format=compact ${csslint_ignores} $* | grep -v '\(Warning\|Is the file empty\|^$\)'
}
# shellcheck disable=SC2139
alias csslintr="find . -name '*.css' -exec csslint --quiet --format=compact ${csslint_ignores} \\{\\} \\; | grep -v '\\(Warning\\|Is the file empty\\|^\$\\)'"

phplintr() {
    output=$(find . -name "*.php" -exec php -n -l \{\} \;)
    status=$?
    echo "$output" | grep -v "^No syntax errors detected in"
    return $status
}

if [ -f /usr/share/dict/words ]; then
    alias apg='apg -a1 -m5 -x10 -n1 -MNCLS -r/usr/share/dict/words'
else
    alias apg='apg -a1 -m5 -x10 -n1 -MNCLS'
fi

alias rdpcoda="xfreerdp -u 'codaagency\\fatsoma' -p '!f4ts0m4!' remote.codaagency.com"

dual_monitor() {
    local otherscreen=${1:-VGA1} # or commonly HDMI1
    local side=${2:-left}
    xrandr --output "${otherscreen}" "--${side}-of" LVDS1 --auto
}
single_monitor() {
    local otherscreen=${1:-VGA1} # or commonly HDMI1
    xrandr --output "${otherscreen}" --off
}

alias be="bundle exec"
alias bundleinstall="bundle install -j4 --binstubs .bundle/bin"
alias bundle4="bundle -j4; echo a | bundle exec rake rails:update:bin"
alias sshops="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias scpops="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias v2_flood_create_event="gatling -sf \${HOME}/v2/v2-load-tests/simulations -s CreateEventSimulation | grep -A1 'EVENT VANITY NAME' | tail -n 1"

alias grep_chef_attributes_dot_syntax="grep -RP '(?<!['\\''/\"])\\b(?!node\\.name)(node|(force_)?(default|override)|normal|automatic|set(_unless)?)\\b\\.(?!((force_)?(default|override)|normal|automatic|set(_unless)?|to_[ahis]|tr|g?sub|(chef_)?environment|run_state|recipes|fetch|inspect|each|map|join)\\b|\\w+\\?)'"

v2_out_of_date() {
  ENVIRONMENT=${ENVIRONMENT:-$1}
  (
    cd ~/v2/tools || (echo could not find ~/v2/tools ; exit)
    bin/tools deploys:current_sha all "${ENVIRONMENT}" | grep 'out of date' | sed 's/^.*\(https.*\)$/\1/' | sort | uniq | xargs chromium
  )
}

v2_action_from_dir() {
  action=$1
  process=$2
  dir=$(basename "$(pwd)" | sed 's/^v2-//')
  if [ -n "$process" ] ; then
    unit="fatsoma-development-$dir-$process.service"
  else
    unit="fatsoma-$dir.target"
  fi
  case "${dir%%-*}" in
    service|user|api|explore)
      sudo systemctl "$action" "$unit"
      ;;
    *)
      echo "Unknown service in ${dir}"
      return 1
      ;;
  esac
}

v2_start() {
  v2_action_from_dir 'start' "$@"
}
v2_restart() {
  v2_action_from_dir 'restart' "$@"
}
v2_stop() {
  v2_action_from_dir 'stop' "$@"
}
v2_status() {
  v2_action_from_dir 'status' "$@"
}

alias kitchen='RBENV_VERSION=2.3.1 bundle exec kitchen'

honeybadgerkeys() {
  (
    cd ~/v2 || (echo could not find ~/v2 ; exit)
    for app in * ; do
      [ -f "$app/config/honeybadger.yml" ] && (echo -n "$app " && grep api_key "$app/config/honeybadger.yml") | awk '{ print $3 " " $1 }'
    done
  ) | sort
}

alias bofh="telnet towel.blinkenlights.nl 666"
alias starwars="telnet towel.blinkenlights.nl"

alias curlmyip="curl wtfismyip.com/text"

man() {
    # mb - begin blinking
    # md - begin bold
    # me - end mode
    # se - end standout-mode
    # so - begin standout-mode - info box
    # ue - end underline
    # us - begin underline
    env \
        LESS_TERMCAP_mb="$(printf "\e[1;31m")" \
        LESS_TERMCAP_md="$(printf "\e[1;38;5;74m")" \
        LESS_TERMCAP_me="$(printf "\e[0m")" \
        LESS_TERMCAP_se="$(printf "\e[0m")" \
        LESS_TERMCAP_so="$(printf "\e[38;5;246m")" \
        LESS_TERMCAP_ue="$(printf "\e[0m")" \
        LESS_TERMCAP_us="$(printf "\e[4;37m")" \
            man "$@"
}

alias ri='/usr/bin/ri -d /home/bill/.rbenv/versions/2.0.0-p247/share/ri/2.0.0/system -d /home/bill/.rbenv/versions/2.3.1/share/ri/2.3.0/system'
alias railspry="rails r \"require 'pry'; pry\""
alias transpec='RBENV_VERSION=system transpec'
alias rubymri_lintr="find . -name '*.rb' -not -path '*/generators/*/templates/*' -not -path '*/vendor/*' -exec ruby -W1 -T1 -c \{\} \; | grep -v 'Syntax OK'"
alias pylint='pylint --rcfile=/home/bill/.pylintrc'
alias phpcs='phpcs -s --tab-width=4'
alias ipython2='ipython2 --no-confirm-exit'

alias heroku='RBENV_VERSION=system heroku'
alias heroku_apps='heroku apps | grep -v "^\(===\|$\)" | cut -d" " -f1'

alias tools='bin/tools'

EC() {
  echo -e "\e[1;33mcode $?\e[m"
}
trap EC ERR

aurap() {
  aura -Ap "$1" | view - +setf\ sh
}

homestore() {
  [ -n "$1" ] || (echo 'no directory argument given' ; exit 1)
  local name="${1%/}"
  local homedir="${HOME}/${name}"
  local storedir="/store${homedir}"
  if [ -e "${storedir}" ]; then
    if [ -L "${homedir}" ]; then
      echo 'Already set up'
      exit 0
    else
      if [ -e "${homedir}" ]; then
        echo 'Store and home entries both exist. Resolve this manually'
        exit 1
      else
        ln -sn "${storedir}" "${homedir}"
      fi
    fi
  else
    if [ -d "${homedir}" ] || [ -f "${homedir}" ]; then
      mv "${homedir}" "${storedir}"
    else
      mkdir "${storedir}"
    fi && \
      ln -sn "${storedir}" "${homedir}"
  fi
}
alias find_nonlinks='find . -mindepth 1 -maxdepth 1 -not -type l -print0 | sed -z '\''s;^\./;;'\'' | xargs -0 ls --color -d'

alias rsync_transfer='rsync --exclude=.git --exclude=.svn -alvz --progress'

alias nvidia-settings='optirun -b none nvidia-settings -c :8'

# shellcheck disable=1090
[ -f "$HOME/git/rails_completion/rails.bash" ] && . "$HOME/git/rails_completion/rails.bash"

# shellcheck disable=1091
[ -r /usr/share/git/git-prompt.sh ] && . /usr/share/git/git-prompt.sh
