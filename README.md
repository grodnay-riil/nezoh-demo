
# Zeno-Demo ROS Project

This repository contains a ros2 zeno bridge demo. Two isolated containers with ros two are set up. Between them a Zenoh bridge forwards a topic with 1Hz pacing. The set up is a generic and flexible setup for working with ROS projects using Docker. It ensures that all builds and executions happen inside containers with user permissions matched to your host system. The setup includes scripts for building, running, and interacting with containers seamlessly. (Running - to be completed, see the Nimbro-demo, Also, the base container include user 1000:1000 so this step is skipped)

---

## 🛠️ Workflow Overview

1. **Install** tmux, git ,docker etc...

1. **Clone the Repository:**

   ```bash
   git clone  https://github.com/grodnay-riil/zenoh-demo.git
   cd zenoh-demo
   ```

---

2. **Source the `setup.bash` Script:**

   This script:
   - Sets environment variables (`PROJECT_NAME`, `PROJECT_USER`, `PROJECT_UID`, `PROJECT_GID`).
   - Adds the `scripts` folder to your `PATH`.
   - Prepares the environment for Docker-based ROS development.

   Run:

   ```bash
   source setup.bash
   ```

   **You should see output like:**

   ```
   PROJECT_NAME: nimbro-demo
   PROJECT_USER: nimbro-demo
   PROJECT_DIR: /path/to/nimbro-demo
   UID: 1000, GID: 1000
   ```

---

3. **Build the Project with `build.bash`:**

   Run:

   ```bash
   build.bash
   ```

   This script:
   - Builds Docker images with user permissions matching your host.
   - Runs `rosdep` to install missing ROS dependencies.
   - Compiles the ROS workspace using `colcon build --symlink-install`. **This step is skipped

---

4. **Run the development Containers and build the sub pub package**

   Run:

   ```bash
   run_dev.bash
   colcon build --symilink-install
   ```

   This:
   - Launches the development container.
   - Maps your workspace into the containers.
   - Builds the code

---
4. **Run publisher**
   Open another window, run:
   ```bash
   source scripts/setup.bash
   docker compose run ros_publisher
   ```
   This:
      - Launches the publisher container.
      - launches the publisher
   You should see the publisher log sending 10 messages per second
   4. **Run subscriber**
Open another window, run:
   ```bash
   source scripts/setup.bash
   docker compose run ros_subscriber

   ```
   This:
      - Launches the subscriber container.
      - launches the subscriber
   We have no bridge, so you should see the subscriber waiting

4. **Run Zeno Bridge**
   Open another window under publisher, run:
   ```bash
   docker exec -it zenoh-demo-ros_publisher-run- <TAB><TAB> bash
   zenoh-bridge-ros2dds -c zenoh_pub.config.json5
   ```
   And in another window:
   ```bash
   docker exec -it zenoh-demo-ros_subscriber-run- <TAB><TAB> bash
   zenoh-bridge-ros2dds -c zenoh_sub.config.json5
   ```
   This:
      - runs Zenoh bridge with relevant configuration in subscriber and publisher containers
      - as we user "run" with docker compose our containers have temporary names.
      - You should see the subscriber accept 1 message per second.

5. Play around:
   - by changin the Zenoh config files and relaunching Zenoh.
   - You can check throughput by connecting to one of the subscriber or publisher containers  anr running:
   ```bash
   nload
   ```

6. **Stop All Containers with `kill_all.bash`:**

   Run (outside of container):

   ```bash
   kill_all.bash
   ```

   This script stops and removes all containers to keep things clean.

---
