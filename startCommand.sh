#!/bin/bash

# Source the paths from paths.txt
if [ -f "paths.txt" ]; then
    source paths.txt
else
    echo "Error: paths.txt not found. Please run setup_paths.sh first."
    exit 1
fi

# Check if paths are set
if [ -z "$configPath" ] || [ -z "$dataPath" ]; then
    echo "Error: configPath or dataPath not set in paths.txt. Please run setup_paths.sh first."
    exit 1
fi

# Check if files/directories exist
if [ ! -f "$configPath" ]; then
    echo "Error: Config file '$configPath' does not exist."
    exit 1
fi

if [ ! -d "$dataPath" ]; then
    echo "Error: Data directory '$dataPath' does not exist."
    exit 1
fi

echo "Starting Docker container with:"
echo "  Config: $configPath"
echo "  Data: $dataPath"
echo ""

docker run --privileged -it \
  -v "$dataPath:$dataPath" \
  -v "$configPath:/$(basename "$configPath")" hpc-sim:rocky9 /bin/bash
