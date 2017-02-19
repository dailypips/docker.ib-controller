#!/bin/bash

. ib-controller.config

PS3='Please enter your choice: '

options=("run" "status" "chown" "start" "stop" "build" "access" "attach" "export image" "load image" "quit")

select opt in "${options[@]}"
do
    case $opt in
        "run")
					sudo docker stop ib-controller-$IBC_NAME
					sudo docker container rm ib-controller-$IBC_NAME
					sudo docker run -d --name=ib-controller-$IBC_NAME -v $IBC_CONFIG:/root/IBController/IBController.ini -v $IBC_LOG:/root/IBController/Logs -v $IB_CONFIG_DIR:$IB_CONFIG_DIR -h ib-controller-$IBC_NAME -p $IB_PORT:4001 -p $SSH_PORT:22 ib-controller
				;;
        "status")
					sudo docker ps -a
				;;
        "chown")
					sudo chown -R $USER:$USER $IBC_LOG
					sudo chown -R $USER:$USER $IB_CONFIG_DIR
				;;
        "start")
					sudo docker start ib-controller-$IBC_NAME
				;;
        "stop")
					sudo docker stop ib-controller-$IBC_NAME
				;;
        "build")
					sudo docker build -t ib-controller -f Dockerfile .
				;;
        "access")
					sudo docker exec -it ib-controller-$IBC_NAME bash
				;;
        "attach")
					sudo docker attach ib-controller-$IBC_NAME
				;;
        "export image")
					#exports the image so you can use it on another machine
					sudo docker save -o docker.ib-controller.tar ib-controller
					sudo chown $USER:$USER docker.ib-controller.tar
				;;
        "load image")
					#loads an exported image
					sudo docker load -i docker.ib-controller.tar
				;;
        "quit")
            break
        ;;
        *)
            echo invalid option
        ;;
    esac
done
