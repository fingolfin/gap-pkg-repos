#!/usr/bin/env bash
set -e

start=$PWD
for d in $(find [s-zS-Z]* -mindepth 1 -maxdepth 1 -name .git)
#for d in $(find . -mindepth 2 -maxdepth 2 -name .git)
do
    cd $start/$d/..
    d=${PWD#"$start/"}

    echo -e "\e[35m### $d \e[32m($(git symbolic-ref --short HEAD))\e[0m"

    case "$d" in
      CAP_project* | homalg_project* | polycyclic* | modisom* | sglppow* | SymbCompCC* )
        echo "skipping (on ignore list)"
        echo
        continue
        ;;
    esac

    git branch gh-pages origin/gh-pages 2>/dev/null || :
    if ! git show-ref -q origin/gh-pages
    then
        echo "skipping (NOT USING gh-pages)"
        echo
        continue
    fi

    # create gh-pages dir
    test -d gh-pages || git worktree add gh-pages gh-pages
    cd gh-pages
    
    if ! test -f update.g || ! git merge-base gh-pages gh-gap/gh-pages >/dev/null
    then
        echo "skipping (NOT USING GitHubPagesForGAP)"
        echo
        continue
    fi

    # ensure checked out content is up-to-date    
    echo "updating gh-pages worktree"
    git pull --ff-only -q

    # ensure gh-gap remote is up-to-date
    echo "fetching latest GitHubPagesForGAP version from gh-gap remote"
    git remote add gh-gap https://github.com/gap-system/GitHubPagesForGAP 2>/dev/null ||
        git remote set-url gh-gap https://github.com/gap-system/GitHubPagesForGAP
    git fetch gh-gap

    # check if any work needs to be done
    merge_base=$(git merge-base gh-pages gh-gap/gh-pages)
    gh_gap=$(git show-ref -s gh-gap/gh-pages)
    if [[ $merge_base = $gh_gap ]]
    then
        echo "already using latest GitHubPagesForGAP"
        echo
        continue
    fi

    # upgrade to latest GitHubPagesForGAP version
    git pull gh-gap gh-pages || :
    #cp ../PackageInfo.g ../README* .
    gap -b update.g
    git add PackageInfo.g README* _data/package.yml
    
    # FIXME: get rid of weird files
    git rm -f _layouts/default.html-e* 2>/dev/null || :

    # open interactive shell
    # TODO: can we add a suggested command, like
    #    git commit -m "Merge gh-gap/gh-pages" && git push && exit
    #    git commit -m "Merge gh-gap/gh-pages" && git push -f && exit
    bash --init-file <(echo "git status")
done
