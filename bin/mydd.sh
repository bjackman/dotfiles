#!/bin/bash

set -eum

infile=$1
shift
outfile=$1
shift

dd if=$infile bs=128M | pv -p | dd of=$outfile bs=128M
