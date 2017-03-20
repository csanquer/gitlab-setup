#/bin/bash

if [ ! -x "$(command -v lsb_release)" ]; then
    if [ -x "$(command -v apt-get)" ]; then
        echo 'install lsb release package'
        sudo apt-get install -y lsb-release
    #elif [ -x "$(command -v yum)" ]; then
    #    sudo yum install -y lsb-release
    fi
fi

distId=`lsb_release -si`
distRelease=`lsb_release -sr`
distCodename=`lsb_release -sc`

if [ "$distId" = 'Debian' -o "$distId" = 'Ubuntu' ]; then
    sudo apt-get update
    sudo apt-get install -y build-essential libffi-dev libssl-dev python python-dev python-setuptools git
    sudo easy_install pip
    sudo pip install -U jinja2 pycparser
    sudo pip install -U ansible
fi
