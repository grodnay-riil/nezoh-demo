
# Nimbro-Demo ROS Project

This repository contains a generic and flexible setup for working with ROS projects using Docker. It ensures that all builds and executions happen inside containers with user permissions matched to your host system. The setup includes scripts for building, running, and interacting with containers seamlessly.

---

## 🛠️ Workflow Overview

1. **Install** tmux, git ,docker etc...

1. **Clone the Repository:**

   ```bash
   git clone --recursive https://github.com/grodnay-riil/nimbro-demo.git
   cd nimbro-demo
   ```

   > **Note:** The `--recursive` flag pulls all submodules automatically.

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
   - Compiles the ROS workspace using `catkin build`.

   **Key Features:**
   - Uses your **UID and GID** to avoid permission issues.
   - Creates a container user based on your **project name** for better identification.

---

4. **Run the Containers with `run.bash`:**

   Run:

   ```bash
   run.bash
   ```

   This script:
   - Launches containers for ROS nodes (e.g., publisher, subscriber).
   - Maps your workspace into the containers.

---

5. **Access a Running Container with `join.bash`:**

   Run:

   ```bash
   join.bash
   ```

   **What this does:**
   - Opens an interactive bash shell inside the `ros_build` container.
   - The prompt reflects your **project-based username**.

---

6. **Stop All Containers with `kill.bash`:**

   Run:

   ```bash
   kill.bash
   ```

   This script stops and removes all containers to keep things clean.

---

## 🔄 Key Features

- **User Permissions:**
  - Matches your host’s UID and GID to avoid permission issues with mounted volumes.
  - Changes the username inside the container to your **project name** for better prompt visibility.

- **ROS Dependency Management:**
  - Runs `rosdep` inside the container to install required packages.
  - Ensures a clean and isolated build environment.

---

## 🛑 Troubleshooting

- **Issue:** `rosdep init` fails due to existing files.
- **Solution:** The Dockerfile handles this by deleting existing sources before re-initializing `rosdep`.

- **Issue:** Permission denied errors.
- **Solution:** Ensure you sourced `setup.bash` correctly to export UID and GID.

---

## 🚀 Future Improvements

- Automate submodule updates on build.
- Enhance error handling in build scripts.

---

## 🏷️ License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Happy ROS Development! 🎉
