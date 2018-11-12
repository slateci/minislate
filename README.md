MiniSLATE Install

First install dependecies: Docker CE and Docker Compose

Docker CE on Ubuntu: https://docs.docker.com/install/linux/docker-ce/ubuntu/

Docker CE on CentOS: https://docs.docker.com/install/linux/docker-ce/centos/

Other operating systems are in the sidebar.

Docker Compose:

Use pip, install with your package manager or [get-pip.py](https://bootstrap.pypa.io/get-pip.py)

Inside the project directory run: ./minislate start

This will take a while. It is pulling dependencies and compiling the Slate project.

Ensure that the 'endpoint' and 'token' files in slate-config have 600 permissions and are owned by root.
The start.sh script will verify these permissions are set correctly and will change them if they are not.

When the process is complete you can issue commands from the slate client in a new terminal:

./minislate slate ...(cluster list, vo list, etc)...

You can also just get a shell in the slate container with: ./minislate shell slate

To turn off the environment but not destroy it, run: ./minislate pause
Then turn it back on with: ./minislate resume

To completely destroy the environment such that it can be created again with start.sh, run: ./minislate purge

Note that this command does not remove the images that were built with the first run of `minislate start`.
It removes the containers and their volumes so any data added by you is destroyed.
Therefore, you will not need to wait for the build process to complete when running `minislate start` again.

To force a rebuild and pull the latest versions of the software run: ./minislate build

The portal is accessible at https://localhost:5000/ on the host machine.
