#!/bin/bash
set -eu

if git diff --cached --quiet; then
    echo "Nothing staged, aborting"
    exit 1
fi

git stash
git checkout master
git stash pop
GIT_EDITOR=vim git commit
git push
git checkout google
git merge --no-edit master
git push
