#!/bin/bash 
# Function that are useful for other cryptotux scripts. 
# This script is meant to be sourced by the main install script and 

latest_release () {
    # Retrieve latest release name from github
    release=$(curl --silent "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name )
    # If first char is "v", remove it
    [[ $(echo $release | cut -c 1) = "v" ]] && release=$(echo $release | cut -c 2-)
    # If empty or null, use provided default
    [[ -z $release || $release = "null" && -n $2 ]] && release=$2
    echo $release
}

error() {
  echo -e "Error: $@ \t[$(date +'%H:%M:%S')]" >&2
}

# Cryptotux commands
cryptotux() {
    if [ -e ~/.cryptotux/scripts/$1.sh ] ; then
        bash ~/.cryptotux/scripts/$1.sh 
    else 
        if [ -e ~/.cryptotux/install/$1.sh ] ; then
            bash ~/.cryptotux/install/$1.sh
        else
            bash ~/.cryptotux/scripts/help.sh
        fi
    fi
}
alias cx="cryptotux"
complete -W "$( { ls ~/.cryptotux/scripts/; ls ~/.cryptotux/install/; }| rev | cut -c 4- | rev )" cx cryptotux

if "$DEBUG"; then
    echo ">> Cryptotux helpers loaded"
 fi

