#!/bin/sh
set -e
find . -maxdepth 3 -type d -name .git -execdir bash -c \
    'echo -e "\e[35m### $(pwd | xargs basename) \e[32m($(git symbolic-ref --short HEAD))\e[0m" && git st && echo' \;

find . -maxdepth 2 -type d -name .hg -execdir bash -c "echo -ne '\e[35m### ' && (pwd | xargs basename) && echo -ne '\e[0m' && hg st && echo" \;
