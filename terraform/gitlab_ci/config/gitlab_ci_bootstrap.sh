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
source $scriptDir/gitlab_ci_env.sh

# generate gitlab ci runner config file
jinja2 $scriptDir/runner_config.toml.j2 $scriptDir/gitlab_ci_env.yml > /etc/gitlab-runner/config.toml
