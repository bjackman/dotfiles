#!/bin/bash
set -eu

if git diff --cached --quiet; then
    echo "Nothing staged, aborting"
    exit 1
fi

git stash
git checkout master
git stash pop --index
GIT_EDITOR=vim git commit
git push
git stash
git checkout google
git stash pop
git merge --no-edit master
git push
