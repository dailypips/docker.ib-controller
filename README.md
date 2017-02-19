run ib-controller in a docker image an control it via xpra - exposes port 4001

Building docker image
---------------------

1. install `docker`
2. run `docker.sh` select build
3. run `docker.sh` select run
4. run `docker.sh` select chown

now IB gateway is running you can attach through script `xpra.attach.sh`

#### TODO
* using dockers user namespace to mount the container with host UUID so that there is no need to chown the mounted files
* adding ssh access to the container, so that a ssh xpra connection is possible, no socket usage. So you can access the docker container without pre-accessing the host
* use autossh to bind the remote ports to local ports, so that the ssh container isn't exposed
