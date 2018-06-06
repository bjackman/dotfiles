#!/bin/bash

# Adds an SSH key to a rmeote host's authorized_keys

host=$1

if [ -z "$host" ]; then
    echo "single arg should be host to SSH into"
    exit 1
fi

cat ~/.ssh/id_rsa.pub | ssh $host "cat >> ~/.ssh/authorized_keys"
