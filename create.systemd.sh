#!/bin/bash

CONFIGS=configs/*.config

mkdir -p systemd
rm systemd/*

for conf in $CONFIGS
do
		. $conf
		NAME="ib-controller-$IBC_NAME"

		echo "[Unit]" >> systemd/docker-${NAME}.service
		echo "Description=docker ${NAME} container" >> systemd/docker-${NAME}.service
		echo "Requires=docker.service" >> systemd/docker-${NAME}.service
		echo "After=docker.service" >> systemd/docker-${NAME}.service
		echo "" >> systemd/docker-${NAME}.service
		echo "[Service]" >> systemd/docker-${NAME}.service
		echo "Restart=always" >> systemd/docker-${NAME}.service
		echo "ExecStart=/usr/bin/docker start -a ${NAME}" >> systemd/docker-${NAME}.service
		echo "ExecStop=/usr/bin/docker stop -t 10 ${NAME}" >> systemd/docker-${NAME}.service
		echo "ExecStopPost=/usr/bin/docker rm -f ${NAME}" >> systemd/docker-${NAME}.service
		echo "" >> systemd/docker-${NAME}.service
		echo "[Install]" >> systemd/docker-${NAME}.service
		echo "WantedBy=default.target" >> systemd/docker-${NAME}.service

done
