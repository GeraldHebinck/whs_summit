#!/bin/bash
# script to setup Summit_XL-Workspace with ROS Melodic
# based on https://github.com/ProfJust/ero/blob/master/ero_install/install_summit_pkg_on_remote_pc.sh

echo -e "\033[1;92m ---------- Skript zur Einrichtung des SummitXL Workspace in ROS Melodic ------------ \033[0m "
echo -e "\033[42m ---------- Systemupdates werden ausgefuehrt - Passwort erforderlich  ------------ \033[0m "

sudo apt update
sudo apt dist-upgrade -y

cd ~/catkin_ws/src/

echo -e "\033[42m ---------- Installation der noetigen ROS-Pakete  ------------ \033[0m "
sudo apt install ros-melodic-navigation -y
sudo apt install ros-melodic-robot-localization -y
sudo apt install ros-melodic-mavros-* -y
sudo apt install ros-melodic-gmapping -y
sudo apt install ros-melodic-teb-local-planner -y
sudo apt install ros-melodic-nmea-navsat-driver -y
sudo apt install ros-melodic-twist-mux -y
sudo apt install ros-melodic-gazebo-ros-control -y
sudo apt install ros-melodic-teleop-twist-keyboard -y
sudo apt install ros-melodic-tf2-sensor-msgs -y
sudo apt install ros-melodic-velocity-controllers -y
sudo apt install ros-melodic-urg-node -y
sudo apt install ros-melodic-depthimage-to-laserscan -y
sudo apt install ros-melodic-ira_laser_tools -y
sudo apt install ros-melodic-rgbd-launch ros-melodic-libuvc ros-melodic-libuvc-camera ros-melodic-libuvc-ros -y
sudo apt install libsdl-image1.2-dev libsdl1.2-dev -y
sudp apt install ros-melodic-robotnik-base-hw-lib ros-melodic-robotnik-msgs -y
sudo apt install ros-melodic-imu-tools -y
#sudo apt install ros-melodic-summit-xl-robot-control -y //Not avialable

git clone https://github.com/RobotnikAutomation/summit_xl_sim
git clone https://github.com/GeraldHebinck/summit_xl_common
git clone https://github.com/GeraldHebinck/robotnik_sensors
git clone https://github.com/RobotnikAutomation/robotnik_base_hw.git -b melodic-devel
git clone https://github.com/rst-tu-dortmund/costmap_prohibition_layer.git
git clone https://github.com/ros-geographic-info/geographic_info.git
git clone https://github.com/ros-geographic-info/unique_identifier.git
git clone https://github.com/orbbec/ros_astra_camera
git clone https://github.com/orbbec/ros_astra_launch
git clone https://github.com/alin185/whs_summit
git clone https://github.com/GeraldHebinck/summit_xl_controller

echo "source ~/catkin_ws/src/whs_summit/installScript/summitxl_params.env" >> ~/.bashrc


echo -e "\033[42m ---------- Installation PEAK-CAN ---------- \033[0m"
sudo apt install libpopt-dev
cd ~/Downloads 
wget http://www.peak-system.com/fileadmin/media/linux/files/peak-linux-driver-8.10.2.tar.gz
sudo tar -xzf peak-linux-driver-8.10.2.tar.gz
cd peak-linux-driver-8.10.2
sudo make clean
sudo make NET=NO_NETDEV_SUPPORT
sudo make install
sudo cp ~/catkin_ws/src/whs_summit/installScript/46-pcan.rules /etc/udev/rules.d/
sudo service udev reload
sudo service udev restart
sudo udevadm trigger
sudo rmmod pcan
sudo modprobe pcan

echo -e "\033[42m ---------- Installation GeographicLib ---------- \033[0m"
sudo apt install geographiclib-tools 
cd ~/Downloads
wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
chmod +x install_geographiclib_datasets.sh
sudo ./install_geographiclib_datasets.sh

echo -e "\033[42m ---------- Installation PS4 Controller ---------- \033[0m"
sudo apt-get install python-pip
sudo /usr/bin/python -m pip install ds4drv
sudo cp ~/catkin_ws/src/whs_summit/installScript/ds4drv.conf /etc

echo -e "\033[42m ---------- Aktualisiere alle Abhaengigkeiten der ROS-Pakete ---------- \033[0m"
source ~/.bashrc
rosdep update
rosdep install --from-paths ~/catkin_ws/src --ignore-src -r -y

echo -e "\033[42m ---------- Ausfuehren von catkin build ---------- \033[0m"
cd ~/catkin_ws/
catkin build

echo -e "\033[42m ---------- SummitXL Workspace ist installiert - have fun! ----------   \033[0m"
