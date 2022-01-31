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
[[ $- = *i* ]] || return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth
alias history_null='export HISTFILE=/dev/null'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ ! -x /usr/bin/lesspipe ] || eval "$(lesspipe)"
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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
grep_excludes='--exclude=".*.swp" --exclude-dir=.svn --exclude-dir=.git --exclude-dir=templates_c --exclude-dir=min --exclude=tags --exclude-dir=vendor --exclude-dir=.bundle --exclude=debug.log --exclude=blog-deleted.php --exclude-dir=blog --exclude-dir=log --exclude-dir=request_cache --exclude-dir=saved_pages --exclude-dir=coverage --exclude-dir=Godeps --exclude-dir=.terraform --exclude-dir="build" --exclude-dir=".idea" --exclude-dir=.kitchen --exclude-dir=node_modules --exclude-dir=dist'
# shellcheck disable=SC2139
alias grep="grep -I ${grep_excludes}"
# shellcheck disable=SC2139
alias fgrep="fgrep -I ${grep_excludes}"
# shellcheck disable=SC2139
alias egrep="egrep -I ${grep_excludes}"
# shellcheck disable=SC2139
alias grepui="grep -I ${grep_excludes} --exclude-dir=public --exclude-dir=tmp"
# shellcheck disable=SC2139
alias greptf="grep -I ${grep_excludes} --exclude-dir=environments"
# shellcheck disable=SC2139
alias greps="grep -I ${grep_excludes} --exclude-dir=spec --exclude-dir=test --exclude-dir=tests --exclude-dir=test-results --exclude-dir=cypress --exclude='*_test.go'"
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    [ ! -e "$HOME/.dir_colors" ] || DIR_COLORS="$HOME/.dir_colors"
    [ -e "$DIR_COLORS" ] || DIR_COLORS=""
    eval "$(dircolors -b $DIR_COLORS)"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
    alias ip='ip --color=auto'

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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

alias gitvimdiff="GIT_PAGER= GIT_EXTERNAL_DIFF=gitvimdiffwrap git diff"

alias grepplatform="grep -I --color=auto --exclude='*.svn-base' --exclude='*.swp' --exclude-dir='codapreview' --exclude-dir='.svn'"
alias sedgrepfile="sed 's/^\\([^:]*\\):.*\$/\\1/' | sort -u"

alias findlarge='du -shx .* * --exclude="." --exclude=".." | grep "^[0-9.]*[MG]"'

gvimdiffr() {
  local left_dir=$1
  local right_dir=$2

  diff -rq "$left_dir" "$right_dir" |\
    grep '^Files' | sed 's/^Files \(.*\) differ$/\1/' |\
    while read -r line; do
      left=${line%% and *}
      right=${line#* and }
      gvimdiff -f "$left" "$right"
    done
}

alias find_wcount='find . -path \*.svn\* -prune -o -path \*.git\* -prune -o -path \*vendor\* -prune -o -regex ".*\.\(php\|css\|s[ac]ss\|js\|cs\|coffee\|rb\|rake\|py\|sh\)" -type f'
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
    alias apg="apg -a1 -m20 -x20 -n1 -MNCLS -E'#\\\\\"'\\' -r/usr/share/dict/words"
else
    alias apg="apg -a1 -m20 -x20 -n1 -MNCLS -E'#\\\\\"'\\'"
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

export BUNDLE_BUILD__SASSC=--disable-lto # fix for sassc ~> 2.2.0 (where linux binaries no longer provided)

v2_out_of_date() {
  local _env=$1
  (
    cd ~/v2/tools || (echo could not find ~/v2/tools ; return 1)
    bin/tools deploys:current_sha all "${_env}" | grep 'out of date' | sed 's/^.*\(https.*\)$/\1/' | sort -u | xargs -n1 firefox &>/dev/null &
  )
}

tf_current_sha() {
  local _env=$1
  local _group=$2
  v2-terraform-tools aws ec2 current_sha -e "$_env" -g "$_group" | grep https | sed 's/^.*\(https.*\)$/\1/' | sort -u | xargs -n1 firefox &>/dev/null &
}

v2_action_from_dir() {
  action=$1
  process=$2
  dir=$(basename "$PWD" | sed 's/^v2-//')
  if [ -n "$process" ] ; then
    unit="fatsoma-development-$dir-$process.service"
  else
    unit="fatsoma-$dir.target"
  fi
  case "${dir%%-*}" in
    service|user|api|explore)
      case "$action" in
        status)
          systemctl "$action" "$unit"
          ;;
        log)
          journalctl -u "$unit"
          ;;
        *)
          sudo systemctl "$action" "$unit"
          ;;
      esac
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
v2_enable() {
  v2_action_from_dir 'enable' "$@"
}
v2_disable() {
  v2_action_from_dir 'disable' "$@"
}
v2_log() {
  v2_action_from_dir 'log' "$@"
}

honeybadgerkeys() {
  (
    cd ~/v2 || (echo could not find ~/v2 ; return 1)
    for app in * ; do
      [ -f "$app/config/honeybadger.yml" ] && (echo -n "$app " && grep api_key "$app/config/honeybadger.yml") | awk '{ print $3 " " $1 }'
    done
  ) | sort
}

alias bofh="telnet towel.blinkenlights.nl 666"
alias starwars="telnet towel.blinkenlights.nl"

alias curlmyip="curl https://ipv4.wtfismyip.com/text"

man() {
    # mb - begin blinking
    # md - begin bold
    # me - end mode
    # se - end standout-mode
    # so - begin standout-mode - info box
    # ue - end underline
    # us - begin underline
    local e
    e="$(printf '\e')"
    env \
        LESS_TERMCAP_mb="${e}[1;31m" \
        LESS_TERMCAP_md="${e}[1;38;5;74m" \
        LESS_TERMCAP_me="${e}[0m" \
        LESS_TERMCAP_se="${e}[0m" \
        LESS_TERMCAP_so="${e}[38;5;246m" \
        LESS_TERMCAP_ue="${e}[0m" \
        LESS_TERMCAP_us="${e}[4;37m" \
            man "$@"
}

alias ri='/usr/bin/ri -d /home/bill/.rbenv/versions/2.0.0-p247/share/ri/2.0.0/system -d /home/bill/.rbenv/versions/2.3.1/share/ri/2.3.0/system'
alias railspry="rails r \"require 'pry'; pry\""
alias transpec='RBENV_VERSION=system transpec'
alias rubymri_lintr="find . -name '*.rb' -not -path '*/generators/*/templates/*' -not -path '*/vendor/*' -exec ruby -W1 -T1 -c \\{\\} \\; | grep -v 'Syntax OK'"
alias pylint='pylint --rcfile=/home/bill/.pylintrc'
alias phpcs='phpcs -s --tab-width=4 --colors --report=full'
alias ipython2='ipython2 --no-confirm-exit'

alias heroku='RBENV_VERSION=system heroku'
alias heroku_apps='heroku apps | grep -v "^\(===\|$\)" | cut -d" " -f1'

alias tools='bin/tools'

alias circleci_v2_build='circleci local execute -v ~/v2/circleci/ssh:/home/circleci/.ssh -v ~/v2/circleci/artifacts:/tmp/artifacts -v circleci_vendor:/home/circleci/vendor -v circleci_services:/home/circleci/v2 -v ~/v2/circleci/service-log:/tmp/service-log'

EC() {
  echo -e "\\e[1;33mcode $?\\e[m"
}
trap EC ERR

aurap() {
  aura -Ap "$1" | view - +setf\ sh
}

homestore() {
  [ -n "$1" ] || (echo 'no directory argument given' ; return 1)
  local name="${1%/}"
  local homedir="${HOME}/${name}"
  local storedir="/store${homedir}"
  if [ -e "${storedir}" ]; then
    if [ -L "${homedir}" ]; then
      echo 'Already set up'
      return 0
    else
      if [ -e "${homedir}" ]; then
        echo 'Store and home entries both exist. Resolve this manually'
        return 1
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
alias find_nonlinks="find . -mindepth 1 -maxdepth 1 -not -type l -print0 | sed -z 's;^\\./;;' | xargs -0 ls --color -d"

alias rsync_transfer='rsync --exclude=.git --exclude=.svn -alvz --progress'

alias nvidia-settings='optirun -b none nvidia-settings -c :8'

alias auraAu='sudo aura -Akau -x --build=/home/bill/tmp/aur'
alias auraSyu='sudo aura -Syu'

alias nets='sudo netstat -tulpn'

alias uuid='/usr/bin/uuid'

# Use dynamic linking by default
alias ghc='ghc -dynamic'

alias make_test_richgo='make test | richgo testfilter'

export GOPRIVATE='github.com/fatsoma'

duh() {
  du -had1 "$@" | sort -h
}

ifind() {
  find . -iname "*$**"
}

databagedit() {
  knife data bag edit --secret-file .chef/fatsoma_secret_key "$1" "$2"
}
databagshow() {
  knife data bag show --secret-file .chef/fatsoma_secret_key -F json "$1" "$2" | view - '+setf json'
}

# shellcheck disable=1090
[ ! -f "$GOPATH/src/github.com/fatsoma/v2-terraform-tools/bash_completions.sh" ] || . "$GOPATH/src/github.com/fatsoma/v2-terraform-tools/bash_completions.sh"

# shellcheck disable=1090
[ ! -f "$HOME/git/rails_completion/rails.bash" ] || . "$HOME/git/rails_completion/rails.bash"

# shellcheck disable=1091
[ ! -r /usr/share/git/git-prompt.sh ] || . /usr/share/git/git-prompt.sh

export NVM_DIR="$HOME/.config/nvm"
# shellcheck disable=1090
[ ! -s "$NVM_DIR/nvm.sh" ] || . "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck disable=1090
[ ! -s "$NVM_DIR/bash_completion" ] || . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
