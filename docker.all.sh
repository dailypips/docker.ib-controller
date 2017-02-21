#!/bin/bash

CONFIGS=configs/*.config

PS3='Please enter your choice: '
options=("run" "chown" "stop" "quit")

select opt in "${options[@]}"
do
    case $opt in
        "run")
					for conf in $CONFIGS
					do
						echo "Processing $conf config..."

						. $conf

						sudo docker stop ib-controller-$IBC_NAME
						sudo docker container rm ib-controller-$IBC_NAME
						sudo docker run -d --name=ib-controller-$IBC_NAME -e "TZ=Europe/Berlin" -v $IBC_CONFIG:/root/IBController/IBController.ini -v $IBC_LOG:/root/IBController/Logs -v $IB_CONFIG_DIR:$IB_CONFIG_DIR -h ib-controller-$IBC_NAME -p $IB_PORT:4002 -p $SSH_PORT:22 ib-controller
					done
				;;
        "chown")
	        for conf in $CONFIGS
	        do
						. $conf
						sudo chown -R $USER:$USER $IBC_LOG
						sudo chown -R $USER:$USER $IB_CONFIG_DIR
					done
				;;
        "stop")
					for conf in $CONFIGS
					do
						. $conf
						sudo docker stop ib-controller-$IBC_NAME
					done
				;;
        "quit")
            break
        ;;
        *)
            echo invalid option
        ;;
    esac
done
