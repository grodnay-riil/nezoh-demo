
ARG ROS_DISTRIBUTION=dummy
FROM ros:${ROS_DISTRIBUTION}

# Accept build arguments for user configuration
ARG PROJECT_NAME
ARG PROJECT_USER
ARG PROJECT_UID
ARG PROJECT_GID
ARG ROS_DISTRIBUTION

ENV PROJECT_NAME=${PROJECT_NAME} \
    PROJECT_USER=${PROJECT_USER} \
    PROJECT_UID=${PROJECT_UID} \
    PROJECT_GID=${PROJECT_GID} \
    ROS_DISTRIBUTION=${ROS_DISTRIBUTION}    

RUN echo "*************************${ROS_DISTRIBUTION}*************************"

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3-colcon-common-extensions \
    python3-pip \
    curl \
    build-essential


RUN echo "deb [trusted=yes] https://download.eclipse.org/zenoh/debian-repo/ /" | sudo tee -a /etc/apt/sources.list > /dev/null && \
    apt update && \
    apt install zenoh-bridge-ros2dds

# Install iperf3 for bandwidth testing
RUN apt-get update && apt-get install -y \
    iperf3 \          
    net-tools \       
    iputils-ping \    
    dnsutils \        
    iproute2 \
    nload       
    # && rm -rf /var/lib/apt/lists/*

RUN apt install -y ros-${ROS_DISTRIBUTION}-rmw-cyclonedds-cpp
 # Create a new user and group with matching UID and GID
RUN id -u $PROJECT_USER 2>/dev/null || \
    (groupadd -g $PROJECT_GID $PROJECT_USER && \
    useradd -m -u $PROJECT_UID -g $PROJECT_GID -s /bin/bash $PROJECT_USER && \
    usermod -aG sudo $PROJECT_USER)
#RUN ip l set lo multicast on
# Allow the new user to use sudo without a password
RUN echo "$PROJECT_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Fix rosdep init issue: Create the necessary directory, delete the existing file if it exists, and run rosdep init as root
RUN mkdir -p /etc/ros/rosdep/sources.list.d && \
    if [ -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then sudo rm /etc/ros/rosdep/sources.list.d/20-default.list; fi && \
    sudo rosdep init

# Switch to the new user
USER $PROJECT_USER
WORKDIR /home/$PROJECT_USER

# Run rosdep update as the new user
RUN rosdep update

# Set up a workspace
RUN mkdir -p /home/$PROJECT_USER/$PROJECT_NAME/src
WORKDIR /home/$PROJECT_USER/$PROJECT_NAME

# Copy the entire workspace into the Docker image
COPY --chown=$PROJECT_UID:$PROJECT_GID . /home/$PROJECT_USER/$PROJECT_NAME

# Install dependencies with rosdep as the new user
RUN rosdep install --from-paths src --ignore-src -r -y


# RUN  /bin/bash -c "source /opt/ros/${ROS_DISTRIBUTION}/setup.bash && rm -rf build log install && colcon build --symlink-install --cmake-clean-cache" 
# Source the workspace by default for the new user
RUN echo "source /opt/ros/${ROS_DISTRIBUTION}/setup.bash" >> /home/$PROJECT_USER/.bashrc
RUN echo "source /home/$PROJECT_USER/$PROJECT_NAME/install/setup.bash" >> /home/$PROJECT_USER/.bashrc


# Expose ROS 2 and Zenoh ports
#EXPOSE 7447 7448 1883
# Start with a bash terminal
CMD ["bash"]
