platform=$(uname);
if [[ $platform == 'Linux' ]]; then
    # klogg
    export WORKON_HOME=$HOME/dev/virtualenvs
    export PROJECT_HOME=$HOME/dev
elif [[ $platform == 'Darwin' ]]; then
    # robotbill
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Dropbpx/dev
fi

source /usr/local/bin/virtualenvwrapper.sh
