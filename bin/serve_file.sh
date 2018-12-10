#!/bin/bash

set -eux

PORT=8080
python -m SimpleHTTPServer $PORT &
pid=$!

path=$1
echo Try http://$(hostname):$PORT/$path

function cleanup() {
    kill $pid
}

trap cleanup EXIT

echo Press any key to kill server

read


