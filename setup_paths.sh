#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== HPC Simulation Path Setup ===${NC}"
echo ""

# Function to validate if file/directory exists
validate_path() {
    local path="$1"
    local path_type="$2"
    
    if [ "$path_type" = "config" ]; then
        if [ -f "$path" ]; then
            return 0
        else
            echo -e "${RED}Error: Config file '$path' does not exist!${NC}"
            return 1
        fi
    elif [ "$path_type" = "data" ]; then
        if [ -d "$path" ]; then
            return 0
        else
            echo -e "${RED}Error: Data directory '$path' does not exist!${NC}"
            return 1
        fi
    fi
}

# Function to get absolute path
get_absolute_path() {
    local path="$1"
    if [[ "$path" = /* ]]; then
        echo "$path"
    else
        echo "$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
    fi
}

# Get config path
echo -e "${YELLOW}Enter the path to your config file:${NC}"
echo "Example: /path/to/config.yaml or ./config.yaml"
read -p "Config path: " configPath

# Validate and get absolute path for config
if validate_path "$configPath" "config"; then
    configPath=$(get_absolute_path "$configPath")
    echo -e "${GREEN}✓ Config file found: $configPath${NC}"
else
    echo -e "${RED}Please provide a valid config file path.${NC}"
    exit 1
fi

echo ""

# Get data path
echo -e "${YELLOW}Enter the path to your data directory:${NC}"
echo "Example: /path/to/data or ./data"
read -p "Data path: " dataPath

# Validate and get absolute path for data
if validate_path "$dataPath" "data"; then
    dataPath=$(get_absolute_path "$dataPath")
    echo -e "${GREEN}✓ Data directory found: $dataPath${NC}"
else
    echo -e "${RED}Please provide a valid data directory path.${NC}"
    exit 1
fi

echo ""

# Update paths.txt
echo "configPath='$configPath'" > paths.txt
echo "dataPath='$dataPath'" >> paths.txt

echo -e "${GREEN}✓ Paths saved to paths.txt${NC}"
echo ""

# Generate start command
echo -e "${BLUE}=== Generated Start Command ===${NC}"
echo "docker run --privileged -it \\"
echo "  -v $dataPath:$dataPath \\"
echo "  -v $configPath:/$configPath") hpc-sim:rocky9 /bin/bash"
echo ""

# Ask if user wants to run the command now
read -p "Do you want to run the start command now? (y/n): " run_now

if [[ $run_now =~ ^[Yy]$ ]]; then
    echo -e "${GREEN}Starting Docker container...${NC}"
    docker run --privileged -it \
      -v "$dataPath:$dataPath" \
      -v "$configPath:/$configPath" hpc-sim:rocky9 /bin/bash
else
    echo -e "${YELLOW}You can run the start command manually using the generated command above.${NC}"
fi
