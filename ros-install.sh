#! /bin/bash

# Update package repository
function update()
{
	echo ""
	echo "Updating package library."
	echo ""
	apt-get update -y
}

# Checking if running correct Ubuntu version
VERSION="$(lsb_release -c | cut -f 2)"

if [[ "$VERSION" == "focal" ]]; then
	echo "Running Ubuntu 20.04 or compatable."
else
	echo "You must be running Ubuntu 20.04 to install ROS."
	exit 1
fi

# Checking if running as sudo or root
if [[ "$(whoami)" == "root" ]]; then
	echo ""
	echo "Running script as root."
else
	echo ""
	echo "Script must be run as root or using sudo."
	exit 1
fi

update

# Install needed helper programs
echo ""
echo "Installing helper programs."
echo ""
apt-get install curl git vim -y

# Configure Ubuntu package sources
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ focal universe multiverse restricted"
add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ focal-updates universe multiverse restricted"

# Configure ROS package mirrors
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# Install ROS signing keys
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

update

# Actually install ROS and friends
echo ""
echo "Installing ROS packages."
echo ""
apt-get install ros-noetic-desktop-full python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool python3-catkin-tools build-essential -y

# Setup shell environment
echo "source /opt/ros/noetic/setup.bash" >> /home/$SUDO_USER/.bashrc

# Initialize ROS dependency manager
echo ""
echo "Initializing ROS dependency manager."
echo ""

rosdep init
sudo -u $SUDO_USER rosdep update

echo ""
echo ""
echo "ROS Noetic has been successfully installed."
