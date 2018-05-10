#!/bin/bash

set -eu

PORT=8080
python -m SimpleHTTPServer $PORT &
pid=$!

path=$1
echo Try http://$(hostname):$PORT/$path

echo Press any key to kill server

read

kill $pid

