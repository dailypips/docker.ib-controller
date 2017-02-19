#!/bin/bash

. ib-controller.config

xpra attach ssh/root@127.0.0.1:$SSH_PORT/100
