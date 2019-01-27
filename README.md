# MiniSLATE

This project is a local distribution of the [SLATE project](http://slateci.io/) with a single Kubernetes node.

This project utilizes a 'docker-in-docker' architecture. The entire environment is enclosed in Docker containers, including Kubernetes.

The primary purpose of this project is to provide a local development environment for SLATE applications with minimal host dependencies and less resources than VMs.

## Minimum Requirements

2 cores CPU and 4GB RAM recommended for minimum reasonable performance.

At least 10GB available disk is recommended. Kubernetes will take up a few GB alone.

## Install Dependencies

### Docker CE:

Docker CE on CentOS: https://docs.docker.com/install/linux/docker-ce/centos/

Docker CE on Ubuntu: https://docs.docker.com/install/linux/docker-ce/ubuntu/

Other Linux operating systems are in the sidebar.

### Docker Compose:

Use [pip](https://github.com/pypa/pip). It can be installed with your package manager or [get-pip.py](https://bootstrap.pypa.io/get-pip.py)

Then run: `(sudo) pip install docker-compose`

### SLATE Docker Images:

Inside the project directory run: `./minislate build`

This will take a minute or so. It is pulling container dependencies and the SLATE project.

## Usage

Run `./minislate init` to spin up the containers for the MiniSLATE environment and install Kubernetes.

When the process is complete you can issue commands from the slate client in a new terminal:

`./minislate slate ...(cluster list, vo list, etc)...`

You can also just get a shell in the slate container with: `./minislate shell slate`

To pause/suspend the environment run: `./minislate pause`
Then turn it back on with: `./minislate unpause`

To **completely destroy** the environment such that it can be created again run: `./minislate destroy`

`./minislate build` can be run again before re-initializing the environment with `./minislate init`

`./minislate build` will always pull the latest releases of the SLATE software.
