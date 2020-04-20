# MiniSLATE
This project provides a local development environment for the [SLATE project](http://slateci.io/).

## Minimum Requirements
- Linux (2 cores, 4GB memory, 15GB storage) or MacOS
- Python (3 or 2.7, 'python' must be in your PATH)
- [DockerCE](https://docs.docker.com/install/#supported-platforms)
- [Docker-Compose](https://github.com/docker/compose/releases) (installed with Docker for Mac)

On Linux, the user running MiniSLATE must be a member of the Docker group (or root).
Users can be added to the Docker group with: `sudo usermod -a -G docker <username>`

## Getting Started
After installing the dependency requirements and pulling the MiniSLATE repository:

Make sure your Docker is running using `systemctl status docker`.

To start docker run `systemctl enable --now docker`.

On MacOS make sure the Docker Desktop application is running.

If desired, `source shell_aliases` will allow you to run the minislate command and the internal slate and kubectl commands from any directory.

Initialize the environment with `./minislate init`

You can custom build your images using `./minislate build`, but this is not necessary for a functioning minislate environment.

__TIP:__ Access local directories by mapping them into the SLATE container: `./minislate init -v ~/WorkDir:/mnt`

[Utilize SLATE](http://slateci.io/docs/quickstart/slate-client.html#basic-use) with `./minislate slate ...(cluster list, group list, etc)...`

Or shell into the container and run it "natively":
```
$ ./minislate shell slate
# slate ...(cluster list, group list, etc)...
```

To **completely destroy** the environment such that it can be created again run: `./minislate destroy`

Running `./minislate destroy --rmi` will remove the built container images from your machine. This can nescasary if there was a failure or error in the build proccess. It is also needed to completely remove miniSLATE from your machine.

For a more detailed description of each MiniSLATE command view [COMMANDS.md](https://github.com/slateci/minislate/blob/master/COMMANDS.md) 

## Internal Details
MiniSLATE is a docker-compose orchestrated standard SLATE deployment (with a couple performance tweaks for personal machines).

MiniSLATE spins up 4 containers with docker-compose. These include:
- [A Docker-in-Docker Kubernetes node](https://github.com/slateci/minislate/blob/master/kube/Dockerfile)
- [A SLATE management container](https://github.com/slateci/minislate/blob/master/slate/Dockerfile)
- [A DynamoDB container](https://hub.docker.com/r/dwmkerr/dynamodb) used by the SLATE API server
- [A storage container simulating an NFS share](https://hub.docker.com/r/itsthenetwork/nfs-server-alpine)

## Troubleshooting Steps
Many errors that you will encounter with minislate are state related. They may be caused by a interruption in the init or build proccess. Unexpected restarts of certain system daemons can also cause problems. Most state related issues can be resolved by re-initializing the environment. 

`./minislate destroy && ./minislate init`

Be sure this proccess doesn't get interrupted, or you may have to destroy again. At this point if the initialization fails for any reason, you may be dealing with an issue related to the images themselves. To remove and rebuild container images run the following:

`./minislate destroy --rmi && ./minislate init`
