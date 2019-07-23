# Kudos to DOROWU for his amazing VNC 16.04 KDE image
FROM dorowu/ubuntu-desktop-lxde-vnc:xenial
LABEL maintainer "bpinaya@wpi.edu"

# Fix
RUN apt-get update && apt-get install nano -y
RUN apt-get install dirmngr -y

# Adding keys for ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Installing ROS
RUN apt-get update && apt-get install -y ros-kinetic-desktop-full \
		wget git nano
RUN rosdep init && rosdep update

RUN /bin/bash -c "echo 'export HOME=/home/ubuntu' >> /root/.bashrc && source /root/.bashrc"

# Creating ROS_WS
RUN mkdir -p ~/ros_ws/src

# Set up the workspace
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd ~/ros_ws/ && \
                  catkin_make && \
                  echo 'export GAZEBO_MODEL_PATH=~/ros_ws/src/kinematics_project/kuka_arm/models' >> ~/.bashrc && \
                  echo 'source ~/ros_ws/devel/setup.bash' >> ~/.bashrc"


# Updating ROSDEP and installing dependencies
RUN cd ~/ros_ws && rosdep update && rosdep install --from-paths src --ignore-src --rosdistro=kinetic -y

# Sourcing
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && \
                  cd ~/ros_ws/ && rm -rf build devel && \
                  catkin_make"


