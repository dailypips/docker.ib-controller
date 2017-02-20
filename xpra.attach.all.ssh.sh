#!/bin/bash

CONFIGS=configs/*.config

for conf in $CONFIGS
do
    . $conf
    (xpra attach --ssh="ssh -o StrictHostKeyChecking=no" ssh/root@127.0.0.1:$SSH_PORT/100) &
done
