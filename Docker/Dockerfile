FROM ros:noetic-ros-base-focal

SHELL ["/bin/bash", "-c"]

# Set the ROS version
ENV ROS_DISTRO noetic

# Upgrade existing ones
RUN apt update && apt upgrade -y

# TODO: Clean up packages, remove unecessary
# Install packages
RUN apt install -y \
    apt-utils \
    git \
    curl \
    tmux \
    x11-apps \
    python3-pip \
    python-is-python3

# Ouster ROS
RUN apt install -y         \
    build-essential         \
    libeigen3-dev           \
    libjsoncpp-dev          \
    libspdlog-dev           \
    libcurl4-openssl-dev    \
    cmake

# Install ROS packages
RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    # ros-${ROS_DISTRO}-cartographer \
    # ros-${ROS_DISTRO}-cartographer-ros \ 
    # ros-${ROS_DISTRO}-cartographer-ros-msgs \
    # ros-${ROS_DISTRO}-cartographer-rviz \
    ros-${ROS_DISTRO}-controller-manager \
    ros-${ROS_DISTRO}-gazebo-* \
    ros-${ROS_DISTRO}-hector-gazebo-plugins \ 
    ros-${ROS_DISTRO}-hector-gazebo \
    ros-${ROS_DISTRO}-joint-state-controller \
    ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-rviz \
    ros-${ROS_DISTRO}-ros-control \
    ros-${ROS_DISTRO}-rqt-graph \
    ros-${ROS_DISTRO}-rqt-tf-tree \
    # ros-${ROS_DISTRO}-warthog-desktop \
    ros-${ROS_DISTRO}-xacro

RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    ros-${ROS_DISTRO}-diff-drive-controller \
    ros-${ROS_DISTRO}-robot-localization \
    ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-teleop-twist-joy \
    ros-${ROS_DISTRO}-interactive-marker-twist-server \
    ros-${ROS_DISTRO}-twist-mux

RUN DEBIAN_FRONTEND=noninteractive apt install -y \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-cpr-onav-description \
    ros-${ROS_DISTRO}-robot-state-publisher \
    ros-${ROS_DISTRO}-cpr-onav-description \
    ros-${ROS_DISTRO}-rqt-robot-monitor \
    ros-${ROS_DISTRO}-rqt-console \
    ros-${ROS_DISTRO}-joint-state-publisher-gui 

RUN rm -rf /var/lib/apt/lists/*

RUN rosdep update

# Switch to home dir
WORKDIR /root

# Copy the .aliases_bashrc file into the image
COPY .bash_aliases .bash_aliases

# Setup .bashrc
SHELL ["/bin/bash", "-l", "-c"]
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' "/root/.bashrc" \
    && sed -i 's/01;32m/01;36m/g; s/01;34m/01;35m/g' "/root/.bashrc" \
    # Source ROS setup.bash
    && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc \
    && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.profile \
    && echo "source /root/warthog_ws/devel/setup.bash" >> ~/.bashrc

# Copy the entrypoint into the image
COPY ./entrypoint.sh /entrypoint.sh
# Run this script on startup
ENTRYPOINT /entrypoint.sh

# Start container in warthog_ws directory
WORKDIR /root/warthog_ws