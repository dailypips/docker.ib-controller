#!/bin/bash

CONFIGS=configs/*.config

rm used.ports.txt localforward

for conf in $CONFIGS
do
    . $conf
    echo -e "IBC_NAME:\t$IBC_NAME" >> used.ports.txt
    echo -e "IB_PORT:\t$IB_PORT" >> used.ports.txt
    echo -e "SSH_PORT:\t$SSH_PORT" >> used.ports.txt
    echo "LocalForward $IB_PORT localhost:$IB_PORT" >> localforward
    echo "LocalForward $SSH_PORT localhost:$SSH_PORT" >> localforward
    echo "-------------" >> used.ports.txt
done
