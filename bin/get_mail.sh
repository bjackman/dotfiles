#!/bin/bash

set -eux

lei q -I https://lore.kernel.org/all/ -o ~/mail \
    --threads --dedupe=mid --augment \
    'a:jackmanb@google.com AND d:2025-04-01..'
notmuch new
notmuch_propagate_mute.py