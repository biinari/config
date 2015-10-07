# ~/.bash_profile

function append_path() {
    append=$1
    var=${2:-PATH}
    if [ -z ${!var} ]; then
        eval export $var="${append}"
    else
        [[ "${!var}" == *:$append* ]] || eval export $var="${!var}:${append}"
    fi
}
function prepend_path() {
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
if [ -d $HOME/Downloads/android-sdk-linux ] ; then
    append_path $HOME/Downloads/android-sdk-linux/tools:$HOME/Downloads/android-sdk-linux/platform-tools
fi

#put local ghc-6.10.2 to front of the path
#prepend_path $HOME/projects/local/bin

# add cabal path
#prepend_path $HOME/.cabal/bin

# Add Ruby gems path
append_path $HOME/.gem/ruby/2.1.0/bin

# Add Heroku path
prepend_path "/usr/local/heroku/bin"

# Add home bin to path
append_path $HOME/bin

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

## PLATFORM
export PLATFORMCORE="${HOME}/code/svn/fatsoma/platformcore/trunk/"
if [ -d "$PLATFORMCORE" ]; then
	prepend_path "${PLATFORMCORE}shell/bin"
fi

eval "$(rbenv init -)"
export PATH="./bin:${PATH}"

export AWS_CONFIG_FILE="${HOME}/.aws/config"

# Fatsoma v2 config
export CONFIG_PATH="${HOME}/code/v2/core"

# Go language
export GOPATH="${HOME}/code/go"
#append_path "${GOPATH}/bin"
gorun() {
  "${GOPATH}/bin/${*}"
}
_gorun_complete() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=( $(compgen -W "$(ls "${GOPATH}/bin/")" -- $cur) )
}
complete -F _gorun_complete gorun

export GATLING_HOME=/home/bill/Downloads/gatling/gatling-charts-highcharts-bundle-2.1.7

# Only run these on interactive shells
if tty -s ; then
    eval $(keychain --eval --agents ssh -Q --quiet id_rsa ~/code/fatsoma/deployment_and_provisioning/keys/deploy_id_rsa ~/.ssh/bill_fatsoma.pem ~/code/v2/chef/.chef/fatsoma-staging.pem ~/code/v2/chef/.chef/fatsoma-preview.pem ~/code/v2/chef/.chef/fatsoma-production.pem)

    # hub makes git prompt slower, and I can't be bothered tweaking those scripts
    #eval "$(hub alias -s)"
fi
