#!/bin/bash

realpath() {
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
}

# current script command line call
scriptCall="$(realpath "${BASH_SOURCE[0]}")"
# directory of the script
scriptDir=$(dirname "$scriptCall")
# script base name
scriptName=$(basename "$scriptCall")

# get instance config variables
source $scriptDir/gitlab_env.sh

# copy same ssh host keys to all gitlab instance
rm -f /etc/ssh/ssh_host_*
tar -xvzf $scriptDir/ssh_host_keys.tar.gz -C /etc/ssh/
chown -R root:root /etc/ssh/
service ssh restart

# mount gitlab data nfs volume
mkdir -p $gitlab_data_mountpoint
echo "$gitlab_nfs_host:/ $gitlab_data_mountpoint nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
mount -a -t nfs4

# generate gitlab config file and reconfigure gitlab server
jinja2 $scriptDir/gitlab.rb.j2 $scriptDir/gitlab_env.yml > /etc/gitlab/gitlab.rb
gitlab-ctl reconfigure
