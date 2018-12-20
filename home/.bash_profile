#!/bin/bash
# ~/.bash_profile

# shellcheck disable=SC2086
append_path() {
    append=$1
    var=${2:-PATH}
    if [ -z "${!var}" ]; then
        eval export $var="${append}"
    else
        [[ "${!var}" == *:$append* ]] || eval export $var="${!var}:${append}"
    fi
}
# shellcheck disable=SC2086
prepend_path() {
    prepend=$1
    var=${2:-PATH}
    if [ -z ${!var} ]; then
        eval export $var="${prepend}"
    else
        [[ "${!var}" == *$prepend:* ]] || eval export $var="${prepend}:${!var}"
    fi
}

# add jdk to the path
append_path /usr/local/jdk/bin

# add android sdk to the path
if [ -d "$HOME/Downloads/android-sdk-linux" ] ; then
    append_path "$HOME/Downloads/android-sdk-linux/tools:$HOME/Downloads/android-sdk-linux/platform-tools"
fi

#put local ghc-6.10.2 to front of the path
#prepend_path "$HOME/projects/local/bin"

# add cabal path
#prepend_path "$HOME/.cabal/bin"

# Add Ruby gems path
append_path "$HOME/.gem/ruby/2.4.0/bin"

# Add Heroku path
prepend_path "/usr/local/heroku/bin"

# Add home bin to path
append_path "$HOME/bin"

export VISUAL="vim"
export EDITOR="vim"
export LANGUAGE="en_GB:en"
export LANG="en_GB.utf8"
export LC_MESSAGES="en_GB.UTF-8"
export LC_CTYPE="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export EC2_PRIVATE_KEY=~/.ec2/pk-bill_dvwiird.pem
export EC2_CERT=~/.ec2/cert-bill_dvwiird.pem
export EC2_URL=https://ec2.eu-west-1.amazonaws.com

#export TZ="Europe/London"

eval "$(rbenv init - --no-rehash)"

export AWS_CONFIG_FILE="${HOME}/.aws/config"

# Fatsoma v2 config
export CONFIG_PATH="${HOME}/code/v2/fatsoma-settings"
export OPSCODE_USER=bill

# Go language
export GOPATH="${HOME}/code/go"
export GOBIN="${GOPATH}/bin"
append_path "${GOPATH}/bin"
gorun() {
  # shellcheck disable=SC2086
  "${GOPATH}"/bin/${*}
}
# shellcheck disable=2086
_gorun_complete() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(ls "${GOPATH}/bin/")" -- $cur) )
}
complete -F _gorun_complete gorun

export GATLING_HOME=/home/bill/Downloads/gatling/gatling-charts-highcharts-bundle-2.1.7

export NO_AT_BRIDGE=1

# Disable HashiCorp Checkpoint call-home
export CHECKPOINT_DISABLE=1

# Only run these on interactive shells
#if tty -s ; then
#    # shellcheck disable=2046
#    eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)
#fi
