#!/bin/bash

# Example:
# GIT_SEQUENCE_EDITOR="sed -i s/^pick/reword/" GIT_EDITOR=./spellcheck.sh git rebase -i $BASE

sed '/^#/d' -i $1
change_id_line=$(grep "^Change-Id" $1)
sed '/^Change-Id/d' -i $1
hunspell $1
echo $change_id_line >> $1