# MiniSLATE

This project is a local distribution of the [SLATE project](http://slateci.io/) with a single Kubernetes node.

This project utilizes a 'docker-in-docker' architecture. The entire environment is enclosed in Docker containers, including Kubernetes.

The primary purpose of this project is to provide a local development environment for SLATE applications with minimal host dependencies and less resources than VMs.

## Minimum Requirements

MiniSLATE runs on Linux and MacOS.

It is recommended Linux systems have 2 core CPU and 4GB RAM for minimum reasonable performance.

Reasonably modern Mac computers should be adequate.

At least 10GB available disk is recommended. Kubernetes will take up a few GB alone.

## Install Dependencies

### Docker CE:

Docker CE on Ubuntu: https://docs.docker.com/install/linux/docker-ce/ubuntu/

Docker CE on CentOS: https://docs.docker.com/install/linux/docker-ce/centos/

Other Linux operating systems are in the sidebar.

Docker Desktop for MacOS: https://hub.docker.com/editions/community/docker-ce-desktop-mac

### Docker Compose:

Use [pip](https://github.com/pypa/pip), install with your package manager or [get-pip.py](https://bootstrap.pypa.io/get-pip.py)

`(sudo) pip install docker-compose`

MacOS users will have docker-compose installed automatically with Docker Desktop.

### SLATE Docker Images:

Inside the project directory run: `./minislate build`

This will take a minute or so. It is pulling container dependencies and the SLATE project.

## Usage

Run `./minislate start` to spin up the containers for the MiniSLATE environment and install Kubernetes.

NOTE: `./minislate start` will verify that the 'endpoint' and 'token' files in slate-config have 600 permissions and are owned by root. It will use sudo to change them if they are not.

When the process is complete you can issue commands from the slate client in a new terminal:

`./minislate slate ...(cluster list, vo list, etc)...`

You can also just get a shell in the slate container with: `./minislate shell slate`

To turn off the environment but not destroy it, run: `./minislate pause`
Then turn it back on with: `./minislate resume`

To **completely destroy** the environment such that it can be created again run: `./minislate purge`

`./minislate build` can be run again before restarting the environment with `./minislate start`

`./minislate build` will always pull the latest releases of the SLATE software.
