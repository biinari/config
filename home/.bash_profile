# ~/.bash_profile

# add jdk to the path
export PATH=$PATH:/usr/local/jdk/bin

# add android sdk to the path
if [ -d $HOME/Downloads/android-sdk-linux ] ; then
    export PATH=$PATH:$HOME/Downloads/android-sdk-linux/tools:$HOME/Downloads/android-sdk-linux/platform-tools
fi

#put local ghc-6.10.2 to front of the path
#export PATH=$HOME/projects/local/bin:${PATH}

# add cabal path
#export PATH=$HOME/.cabal/bin:$PATH

# Add Ruby gems path
export PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin

# Add home bin to path
export PATH=$PATH:$HOME/bin

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

# Fatsoma profile
FATCOREID="_core/"
FATPARENT="fatsoma/"
FATROOT="/mnt/local/master/"
FATWEBID="web/"
if [ ! -d "$FATROOT" ]; then
    FATCOREID="fatsomacore/"
    FATPARENT=""
    FATROOT="/var/www/"
    FATWEBID=""
fi
export FATCORE="${FATROOT}${FATPARENT}${FATCOREID}"
export FATWWW="${FATROOT}${FATPARENT}${FATWEBID}fatsoma/"
export PYTHONPATH="${FATCORE}shell/lib:${FATCORE}projects:${PYTHONPATH}"
export PATH="${FATCORE}shell/bin:/var/lib/gems/1.8/bin:${PATH}"
export TZ="Europe/London"

## PLATFORM
export PLATFORMCORE="${FATROOT}platform/core/"
if [ -d "$PLATFORMCORE" ]; then
	export PATH="${PLATFORMCORE}shell/bin:${PATH}"
fi

# Exit here for non-interactive shells, they only need the exports and anything after this point may break things
tty -s || return
