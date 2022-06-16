# MiniSLATE

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)

This project provides a local development environment for the [SLATE project](http://slateci.io/).

## Minimum Requirements

- Linux (2 cores, 4GB memory, 15GB storage) or MacOS
- Python (3.9+, 'python' must be in your PATH)
- [DockerCE](https://docs.docker.com/install/#supported-platforms)
- [Docker-Compose](https://github.com/docker/compose/releases) (installed with Docker for Mac)

## Getting Started

### Enable Docker

After installing the dependency requirements and pulling the MiniSLATE repository:
* Make sure your Docker is running using:

  ```shell
  systemctl status docker
  ```
  
* To start Docker run:

  ```shell
  systemctl enable --now docker
  ```
  
* On MacOS make sure the Docker Desktop application is running.
* On Linux, the user running MiniSLATE must be a member of the `docker` group. Users can be added with:

  ```shell
  sudo usermod -a -G docker <username>
  ```

### Configure Shell Aliases (Optional)

The following command will allow you to run the `minislate` command and the internal `slate` and `kubectl` commands from any directory:

```shell
source shell_aliases
 ```

### Initialize MiniSLATE

Initialize the environment with pre-built Docker images:

```shell
./minislate init
```

If you want to map local directories into the SLATE container specify a volume:

```shell
./minislate init -v ~/WorkDir:/mnt
```

#### Build on-the-fly (Optional)

Alternatively, if you need to perform actions like test different versions of the SLATE Portal code other than what is baked into the pre-built Docker image:
1. Modify the `slate/Dockerfile` in this repository.
2. Build the images from source:
   ```shell
   ./minislate build
   ```

### Use SLATE CLI

Run [SLATE CLI](https://slateci.io/docs/tools/index.html) commands by passing them directly to `./minislate`:

```shell
./minislate slate ...(cluster list, group list, etc)...
```

or by starting a shell in the container and running them "natively":

```shell
[your@localmachine]$ ./minislate shell slate
[root@ceb03bcaca72]$ slate ...(cluster list, group list, etc)...
```

### Destroy Environment

To completely destroy the environment so that it can be created again run:

```shell
./minislate destroy
```

To remove the images from your machine entirely add the option: `--rmi`.
* This can necessary if there was a failure or error in the build process.
* It is also needed to completely remove MiniSLATE from your machine.

For a more detailed description of each MiniSLATE command view [COMMANDS.md](https://github.com/slateci/minislate/blob/master/COMMANDS.md) 

## Internal Details

MiniSLATE is a docker-compose orchestrated standard SLATE deployment (with a couple performance tweaks for personal machines). MiniSLATE spins up 4 containers with `docker-compose`. These include:
- [A Docker-in-Docker Kubernetes node](https://github.com/slateci/minislate/blob/master/kube/Dockerfile)
- [A SLATE management container](https://github.com/slateci/minislate/blob/master/slate/Dockerfile)
- [A DynamoDB container](https://hub.docker.com/r/dwmkerr/dynamodb) used by the SLATE API server
- [A storage container simulating an NFS share](https://hub.docker.com/r/itsthenetwork/nfs-server-alpine)

MiniSLATE also includes a `config.py` that may be used to control several parameters including:
* `dockerimage`
* `portalbranch`

## Troubleshooting Steps

Many errors that you will encounter with MiniSLATE are state related. They may be caused by an interruption in the `init` or `build` process. Unexpected restarts of certain system daemons can also cause problems. Most state related issues can be resolved by re-initializing the environment. 

```shell
./minislate destroy && ./minislate init
```

Be sure this process does not get interrupted, or you may have to destroy again. At this point if the initialization fails for any reason, you may be dealing with an issue related to the images themselves. To remove and rebuild container images run the following:

```shell
./minislate destroy --rmi && ./minislate init
```

## Test Infrastructure

It may be necessary to spin up MiniSLATE in an automated way. For example, the Selenium portal tests automatically creates a MiniSLATE cluster to test against. These clusters may require that `tty` is disabled inside the container. `minislate init` can be run with the `--selenium` or `-s` flag to disable `tty` for automated testing.

Example:

```shell
./minislate init -s
```
