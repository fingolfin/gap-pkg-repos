#!/usr/bin/env python2
#
# This script queries GitHub for the latest list of packages in the
# `gap-packages` organization, and then uses git and mercurial to clone any
# of them which have not already been cloned


from __future__ import print_function

import sys
if sys.version_info < (2,7):
    print("Python 2.7 or newer is required")
    exit(1)

import json
import requests
import os
from subprocess import call

print("Fetching repository list from GitHub...")
r = requests.get('https://api.github.com/orgs/gap-packages/repos?per_page=200')
j = r.json();
repos = {item['name']: item['clone_url'] for item in j}

skip = frozenset([
    "gap-packages.github.io",   # not a package
    ])

# add some repos not in the gap-packages org
repos['ArangoDBInterface'] = "https://github.com/homalg-project/ArangoDBInterface"
repos['CAP_project'] = "https://github.com/homalg-project/CAP_project"
repos['crisp'] = "https://github.com/bh11/crisp"
repos['EDIM'] = "https://github.com/frankluebeck/EDIM"
repos['fining'] = "https://bitbucket.org/jdebeule/fining"
repos['fga'] = "https://github.com/chsievers/fga"
repos['GAPDoc'] = "https://github.com/frankluebeck/GAPDoc"
repos['homalg_project'] = "https://github.com/homalg-project/homalg_project"
repos['irredsol'] = "https://github.com/bh11/irredsol"
repos['matgrp'] = "https://github.com/hulpke/matgrp"
repos['simpcomp'] = "https://github.com/simpcomp-team/simpcomp"
repos['transgrp'] = "https://github.com/hulpke/transgrp"

for repo_name in sorted(repos):
    if repo_name in skip:
        continue
    # check if a dir with that name already exists
    if os.path.isdir(repo_name):
        continue
    call(["git", "clone", repos[repo_name]])
    print("")

# also clone some mercurial packages
if not os.path.isdir("forms"):
    print("Cloning forms...")
    call(["hg", "clone", "https://bitbucket.org/jdebeule/forms"])
