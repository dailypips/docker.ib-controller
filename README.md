run ib-controller in a docker image an control it via xpra - exposes port 4001

Building docker image
---------------------

1. `cp ib-controller.config ib-controller.config` and edit `ib-controller.config`
2. `add authorized_keys` file for ssh access
3. install `docker`
4. run `docker.sh` select build
5. run `docker.sh` select run
6. run `docker.sh` select chown

now IB gateway is running you can attach through script `xpra.attach.ssh.sh`

you can use autossh to bind the remote ssh container ports to your local computer, so there is no need to expose the ssh container to the internet.

- for single usage you can symlink from configs dir to ib-controller.config
- for multi usage, copy all your config files to folder configs. you can use docker.all.sh ...
