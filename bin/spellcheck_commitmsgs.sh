#!/bin/bash

# Sole arg is base commit. Optional - defaults to b4 base.

die() {
    echo "$@"
    exit 1
}

if [ -z "$1" ]; then
    BASE=$(b4 prep --show-info start-commit || die "failed to get base commit from b4")
    B4=1
else
    B4=
    BASE="$1"
fi

set -eu

if [ ! -z "$B4" ]; then
    # || true because there's a bug in the git-filter-branch lib that causes it
    # to exit with an error.
    EDITOR=spellcheck_commitmsg.sh b4 prep --edit-cover || true
fi

GIT_SEQUENCE_EDITOR="sed -i s/^pick/reword/" GIT_EDITOR=spellcheck_commitmsg.sh git rebase -i "$BASE"