# Getting Started
Clone this repository.
```
git clone --recurse-submodules -j8 git://github.com/foo/bar.git
```

Adds the lidars to the URDF model by adding this line at the end of `warthog_ws/src/clearpath/warthog/warthog_description/urdf/warthog.urdf.xacro` before `<robot>`.
```
<xacro:include filename="$(find utexas_warthog_simulator)/urdf/ouster.urdf.xacro" />
```

## Docker

Add these lines to your `.bashrc` and adjust for where you clones this repository.
```
source "$HOME/utexas_warthog_docker/Docker/bash_utils"
export WARTHOG_DOCKER_DIRECTORY="$HOME/utexas_warthog_docker"
```

Build the Docker image.
```
wd-build
```

Start the Docker container and shell into it.
```
wd-start
wd-shell
```

Inside the container, launch the Gazebo & RViz simulation.
```bash
runsim
```

Close the Docker container when finished.
```
wd-stop
```
