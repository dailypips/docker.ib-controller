#!/bin/bash

. ib-controler.config

xpra attach socket:$HOME/.xpra/ib-controller-$IBC_NAME-100
