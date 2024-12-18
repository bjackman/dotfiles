#!/bin/bash

# Example:
# GIT_SEQUENCE_EDITOR="sed -i s/^pick/reword/" GIT_EDITOR=spellcheck_commitmsg.sh git rebase -i $BASE

sed '/^#/d' -i $1
change_id_line=$(grep "^Change-Id" $1)
sed '/^Change-Id/d' -i $1
hunspell $1
# Remove blank lines from end of file, otherwise if there's a gap between the
# footers and the change-id, Git gets confused about where the footers start.
sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' $1
echo $change_id_line >> $1