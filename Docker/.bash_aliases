# ----- Current -----
# File navigation
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../../'
function .. () {
    reg='^[0-9]+$'
    if [ -z "$1" ]; then
        cd ../..
    elif ! [[ $1 =~ $reg ]] ; then
        echo "Arg passed must be integer"
    elif [[ $PWD == *$HOME* ]]; then
        LEVEL=`echo "3 + $1" | bc`
        cd $(echo $PWD | cut -f1-$LEVEL -d '/')
    else
        LEVEL=`echo "1 + $1" | bc`
        cd $(echo $PWD | cut -f1-$LEVEL -d '/')
    fi
}

# File/directory size
alias dirsizesGB='sudo du -ha -d 1 . | grep "[0-9]\+[G]" | sort -hr'
alias dirsizesMB='sudo du -ha -d 1 . | grep "[0-9]\+[MG]" | sort -hr'
alias dirsizes='sudo du -ha -d 1 . | sort -hr'

# Sourcing and init ROS workspace
alias sws='source ./devel/setup.bash'

# ROS
alias killros='killall -9 roscore ; killall -9 rosmaster'
alias rnl='rosnode list'
alias rni='rosnode info'
alias rnlg='rosnode list | grep'
alias rtl='rostopic list'
alias rti='rostopic info'
alias rtlg='rostopic list | grep'
alias rpl='rosparam list'
alias rplg='rosparam list | grep'
alias rpg='rosparam get'
alias rps='rosparam set'
alias rosenv='printenv | grep -i ROS'
function unsource_ros () {
    # ROS common
    unset ROS_VERSION
    unset ROS_PYTHON_VERSION
    unset ROS_DISTRO
    unset PYTHONPATH
    unset LD_LIBRARY_PATH
    unset PATH
    PATH=$DEFAULT_PATH

    # ROS 1
    unset ROS_PACKAGE_PATH
    unset ROSLISP_PACKAGE_DIRECTORIES
    unset ROS_ETC_DIR
    unset ROS_MASTER_URI
    unset ROS_ROOT
    unset CMAKE_PREFIX_PATH
    unset PKG_CONFIG_PATH
    unset ROS_LOCATIONS
    unset ROS_HOSTNAME
    unset ROS_NAMESPACE
}

# Catkin
alias catb='catkin build'
alias catbr='catkin build -DCMAKE_BUILD_TYPE=Release'
alias catbd='catkin build -DCMAKE_BUILD_TYPE=Debug'
alias catbrd='catkin build -DCMAKE_BUILD_TYPE=RelWithDebInfo'
function catextend () {
    catkin config --extend /opt/ros/$1
}
alias catm="catkin_make"

# Pkgs
alias grepdpkg='dpkg -l | grep'

# Generic ROS 1 Networking
alias localmaster='export ROS_MASTER_URI=http://localhost:11311 && export ROS_IP=127.0.0.1'
function rosmaster () {
    ROSMASTER="$(getent hosts $1 | cut -d " " -f 1)"
    reg='^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
    if ! [[ $ROSMASTER =~ $reg ]] ; then
        echo "Could not find an IP address for host: $1"
        return 1
    fi

    export ROS_MASTER_URI=http://$ROSMASTER:11311
    echo "ROSMASTER set: $ROSMASTER"
    
    # lookup this device's IP address on the same subnet
    i=1
    LOCALIP="$(hostname -i | cut -d " " -f 1)"
    while [[ $LOCALIP =~ $reg ]]
    do
        if [ "$(echo $ROSMASTER | cut -d "." -f1-3)" == "$(echo $LOCALIP | cut -d "." -f1-3)" ] ; then
            export ROS_IP=$LOCALIP
            echo "ROS_IP set: $ROS_IP"
            return 1
        else
            ((i+=1))
            LOCALIP="$(hostname -i | cut -d " " -f $i)"
        fi

        if ! [[ $LOCALIP =~ $reg ]] || [[ "$(hostname -i)" != *" "* ]] ; then
            break
        fi
    done

    i=1
    LOCALIP="$(hostname -I | cut -d " " -f 1)"
    while [[ $LOCALIP =~ $reg ]]
    do
        PREVIP=$LOCALIP
        if [ "$(echo $ROSMASTER | cut -d "." -f1-3)" == "$(echo $LOCALIP | cut -d "." -f1-3)" ] ; then
            export ROS_IP=$LOCALIP
            echo "ROS_IP set: $ROS_IP"
            return 1
        else
            ((i+=1))
            LOCALIP="$(hostname -I | cut -d " " -f $i)"
        fi

        if ! [[ $LOCALIP =~ $reg ]] || [[ "$(hostname -I)" != *" "* ]] ; then
            echo "Could not find a local ip specificed by 'hostname -i' or 'hostname -I' that is on the same subnet as the rosmaster: $ROSMASTER"
            echo "ROS_IP was not updated"
            break
        fi
    done
}

# rosmaster bash completion
_hostnames()
{
    local cur prev words cword
    _init_completion -n = || return

    if [[ $cur == -* ]]; then
        COMPREPLY=($(compgen -W '$(_parse_usage "$1")' -- "$cur"))
        return
    fi

    _known_hosts_real -- "$cur"
} &&
    complete -F _hostnames rosmaster


export WARTHOG_BULKHEAD=1
alias rmwarthog="export localmaster(ROSMASTER=192.168.131.1)"

runsim() {
    source "$HOME/warthog_ws/devel/setup.bash"
    roslaunch utexas_warthog_simulator warthog_gazebo.launch
}

