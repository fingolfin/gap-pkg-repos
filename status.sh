#!/bin/sh
set -e

start=$PWD
find . -mindepth 2 -maxdepth 3 -name .git -execdir bash -c \
    'echo -e "\e[35m### ${PWD#'"$start/"'} \e[32m($(git symbolic-ref --short HEAD))\e[0m" && git status && echo' \;

find . -maxdepth 2 -type d -name .hg -execdir bash -c "echo -ne '\e[35m### ' && (pwd | xargs basename) && echo -ne '\e[0m' && hg status && echo" \;
