
# MiniSLATE Commands

A listing of all MiniSLATE sub-commands and their arguments.

## `build`

Locally build (or re-build) the MiniSLATE container images to bypass the hosted images.

```shell
$ ./minislate build
```

## `destroy`

Completely destroy the MiniSLATE environment.

```shell
$ ./minislate destroy [--rmi] [-y]
```

### Options

#### `--rmi`

Also remove the built images (they will be rebuilt on next `./minislate init` or manually with `./minislate build`)

#### `-y`

Assume yes for prompt to confirm destroy.

## `exec`

Run any command from the host in a selected MiniSLATE container.

```shell
$ ./minislate exec [container_name] [command]
```

### Required Arguments

#### `container_name`

The container to where the command will be executed. The available containers are:
* `kube`
* `slate`

#### `command`

A valid shell command. For example:

```shell
./minislate exec kubectl uname -a
```

## `init`

Initialize the entire MiniSLATE environment.

```shell
$ ./minislate init [-v hostDir or hostDir:containerDir] [-p hostPort or hostPort:containerPort]
```

### Options

#### `-p, --publish, --port`

Publish a port in the Kubernetes container to the host (e.g. `-p 3000:80`)

#### `-s, --selenium`

For use with automated testing infrastructure. Disables the `tty` option in the docker-compose bring up of MiniSLATE.

#### `-v, --volume`

Create a Docker volume of a host directory to a directory in the SLATE container (e.g. `-v ~/WorkDir:/mnt`).
* If a directory in the container is not specified (e.g. `-v ~/WorkDir`) volumes will be mounted by their directory name under `/mnt` (e.g. `/mnt/WorkDir`).

## `kubectl`

Run a `kubectl` command from the host in the MiniSLATE environment.

```shell
$ ./minislate kubectl [kubectl_command]
```

### Required Arguments

#### `kubectl_command`

A valid `kubectl` command. For example:

```shell
./minislate kubectl get nodes
```

## `pause`

Freezes the state of the MiniSLATE environment (helpful to free up host resources or change host state (sleep, reboots, etc.)

```shell
$ ./minislate pause
```

## `portal`

Open the local copy of the SLATE web interface in a browser.

```shell
$ ./minislate portal
```

## `proxy`

> **_NOTE:_** Arguments and options for this command are mutually exclusive.

Access load-balanced services from the host.

```shell
$ ./minislate proxy [address:port or --list or --rm]
```

### Arguments

#### `address:port`

The command takes an address where traffic will be forwarded. For example:

```shell
$ ./minislate proxy 127.18.0.150:80
```

### Options

#### `--list`

Show a list of currently running proxies.

#### `--rm`

Remove an existing socat process by passing this flag with the PID of the process.

## `reload-catalog`

Reload the catalog from the SLATE stable/incubator repositories.

```shell
$ ./minislate reload-catalog
```

## `status`

View the status of the MiniSLATE environment.

```shell
$ ./minislate status
      Name                     Command               State                                                                                        Ports                                                                                     
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
minislate_db_1      java -jar DynamoDBLocal.jar      Up      8000/tcp                                                                                                                                                                       
minislate_kube_1    /bin/bash -c exec /sbin/in ...   Up      0.0.0.0:30000->30000/tcp, 0.0.0.0:30001->30001/tcp, 0.0.0.0:30002->30002/tcp ... 0.0.0.0:30100->30100/tcp, 0.0.0.0:6443->6443/tcp, 0.0.0.0:8080->80/tcp 
minislate_nfs_1     /usr/bin/nfsd.sh                 Up                                                                                                                                                                                     
minislate_slate_1   /usr/bin/slate-service           Up      0.0.0.0:18080->18080/tcp, 0.0.0.0:5050->5000/tcp, 0.0.0.0:5100->5100/tcp   
```

## `shell`

Open a shell in a MiniSLATE container.

```shell
user@host$ ./minislate shell [containerName]
root@container_id# 
```

### Required Arguments

#### `containerName`

The container to where a shell will be opened. The available containers are:
* `kube`
* `slate`

## `slate`

Run a SLATE CLI command.

```shell
$ ./minislate slate [slate_command]
```

### Required Arguments

#### `slate_command`

A valid SLATE CLI command. For example:

```shell
./minislate slate vo list
```

## `unpause`

Unfreeze the MiniSLATE environment after pausing.

```shell
$ ./minislate unpause
```
