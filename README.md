This repository contains some scripts to clone all GAP packages from
<https://github.com/gap-packages> and some other sources, and then later
update those clones as needed.

clone-gap-packages.py: python script which queries GitHub for the latest
  list of packages in the `gap-packages` organization, and then uses git
  and mercurial to clone any of them which have not already been cloned

update.sh: iterate over all local git and mercurial clones, and
  tries to update them. If local changes prevent this, print an error
  and skip to the next

status.sh: runs `git status` resp. `hg status` in all clones
