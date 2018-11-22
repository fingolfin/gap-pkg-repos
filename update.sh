#!/bin/sh
set -e

start=$PWD
find . -mindepth 2 -maxdepth 3 -name .git -execdir bash -c \
    '
    dir=${PWD#'"$start/"'}
    ref=$(git symbolic-ref --short HEAD)
    echo -e "\e[35m### ${dir} \e[32m(${ref})\e[0m"
    if [ $(basename ${dir}) = gh-pages ] ; then
      [ ${ref} = gh-pages ] || echo -e "\e[31mWarning, expected to be on branch gh-pages\e[0m"
    else
      [ ${ref} = master ] || echo -e "\e[31mWarning, expected to be on branch master\e[0m"
    fi
    git pull --ff-only || echo -e "\e[31mAn error occurred while pulling\e[0m"
    echo
    ' \;

find . -maxdepth 2 -type d -name .hg -execdir bash -c "echo -ne '\e[35m### ' && (pwd | xargs basename) && echo -ne '\e[0m' && hg pull -u ; echo" \;
