FROM ros:noetic-ros-base-focal

SHELL ["/bin/bash", "-c"]

# set the ros version
ENV ROS_DISTRO noetic

# install some useful packages and upgrade existing ones
RUN apt update && apt upgrade -y \
    && apt install -y \
    apt-utils \
    git \
    curl \
    nano \
    vim \
    tmux \
    x11-apps \
    python3-pip \
    python-is-python3
    
# Install Gazebo
# RUN curl -sSL http://get.gazebosim.org | sh

# install ros packages
# see ../docs/installing_ros_packages.md for alternatives
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    ros-${ROS_DISTRO}-rviz \
    ros-${ROS_DISTRO}-rqt-graph \
    ros-${ROS_DISTRO}-rqt-tf-tree \
    ros-${ROS_DISTRO}-warthog-desktop \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    ros-${ROS_DISTRO}-gazebo-ros-control \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep update

# switch to home dir
WORKDIR /root

# setup .bashrc
SHELL ["/bin/bash", "-l", "-c"]
#   # set the bash prompt colors
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' "/root/.bashrc" \
    && sed -i 's/01;32m/01;36m/g; s/01;34m/01;35m/g' "/root/.bashrc" \
    # source ros setup.bash
    && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc \
    && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.profile \
    && echo "source warthog_ws/devel/setup.bash" >> ~/.bashrc
    # add a package to the ROS_PACKAGE_PATH
    # echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/root/amrl_msgs" >> ~/.bashrc \
    # && echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/root/amrl_msgs" >> ~/.profile

    
# copy the entrypoint into the image
COPY ./entrypoint.sh /entrypoint.sh
# run this script on startup
ENTRYPOINT /entrypoint.sh

# Start container in warthog_ws directory
WORKDIR /root/warthog_ws

# Install any missing dependencies
RUN rosdep install --from-paths src --ignore-src --rosdistro=noetic -y