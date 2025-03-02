#!/bin/bash

# Determine the script's directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Set the project name based on the directory name if not set
export PROJECT_NAME="${PROJECT_NAME:-$(basename "$PROJECT_DIR")}"

# Convert PROJECT_NAME to lowercase for the username
export PROJECT_USER="ubuntu"

# Set the project directory environment variable
export PROJECT_DIR="$PROJECT_DIR"

# Get current user ID and group ID
export PROJECT_UID=$(id -u)
export PROJECT_GID=$(id -g)

# Add the scripts directory to the PATH
export PATH="$SCRIPT_DIR:$PATH"

# Print confirmation
echo "PROJECT_NAME: $PROJECT_NAME"
echo "PROJECT_USER: $PROJECT_USER"
echo "PROJECT_DIR: $PROJECT_DIR"
echo "UID: $PROJECT_UID, GID: $PROJECT_GID"
echo "Scripts directory added to PATH: $SCRIPT_DIR"
