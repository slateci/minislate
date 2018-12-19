# MiniSLATE Install

## Install Dependencies:

### Docker CE and Docker Compose

Docker CE on Ubuntu: https://docs.docker.com/install/linux/docker-ce/ubuntu/

Docker CE on CentOS: https://docs.docker.com/install/linux/docker-ce/centos/

Other operating systems are in the sidebar.

### Docker Compose:

Use pip, install with your package manager or [get-pip.py](https://bootstrap.pypa.io/get-pip.py)
Run `(sudo) pip install docker-compose`

### SLATE Docker Images:

Inside the project directory run: `./minislate build`

This will take a while. It is pulling dependencies and the SLATE project.

## Usage:

Run `./minislate start` to spin up the containers for the MiniSLATE environment.

Note `./minislate start` will verify that the 'endpoint' and 'token' files in slate-config have 600 permissions and are owned by root. It will use sudo to change them if they are not.

When the process is complete you can issue commands from the slate client in a new terminal:

`./minislate slate ...(cluster list, vo list, etc)...`

You can also just get a shell in the slate container with: `./minislate shell slate`

To turn off the environment but not destroy it, run: `./minislate pause`
Then turn it back on with: `./minislate resume`

To **completely destroy** the environment such that it can be created again with `./minislate start`, run: `./minislate purge`

`./minislate build` can be run again before rebuilding the environment again with `./minislate start`
This will pull the latest versions of the SLATE software as well.
