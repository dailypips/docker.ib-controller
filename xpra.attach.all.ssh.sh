#!/bin/bash

CONFIGS=configs/*.config

for conf in $CONFIGS
do
    . $conf
    (xpra attach --bell=no --cursors=no --keyboard-sync=no --notifications=no --clipboard=no --opengl=no --ssh="ssh -o StrictHostKeyChecking=no" ssh/root@127.0.0.1:$SSH_PORT/100) &
done
