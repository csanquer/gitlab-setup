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


gitlab_dir=/var/opt/gitlab
source $scriptDir/gitlab_env.sh

mkdir -p $gitlab_dir
# chown git:root $gitlab_dir

echo "$gitlab_nfs_host:/ $gitlab_dir nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" >> /etc/fstab
mount -a -t nfs4

jinja2 $scriptDir/gitlab.rb.j2 $scriptDir/gitlab_env.yml > /etc/gitlab/gitlab.rb

#sudo gitlab-ctl reconfigure
#sudo gitlab-ctl restart
