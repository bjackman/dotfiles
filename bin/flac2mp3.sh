#!/bin/bash
set -eu

# Fuck bash. The following line doesn't work with filenames with space, even
# when they're quoted. Hence the ridiculous loop style.
# for f in $*; do
while [ $# -ne 0 ]; do
  avconv -i "$1" -qscale:a 0 "${1/%flac/mp3}"
  shift
done
