#!/bin/sh

# Determine package manager
read -p "Choose package manager (apt/pacman): " packageManager

# Set sudo command based on user choice
if [ "$packageManager" = "apt" ]; then
    useSudo='sudo'
elif [ "$packageManager" = "pacman" ]; then
    useSudo='sudo'
else
    echo "Invalid package manager choice. Exiting."
    exit 1
fi

# Check if running as root
if [ "$(id -u)" -eq 0 ]; then
    useSudo=''
fi

# Function to update and upgrade using the chosen package manager
updg() {
    local useSudo=$1

    if [ "$packageManager" = "apt" ]; then
        $useSudo "$packageManager"-get update && $useSudo "$packageManager"-get upgrade -y
    elif [ "$packageManager" = "pacman" ]; then
        $useSudo "$packageManager" -Syu
    fi
    
    if [ $? -eq 0 ]; then
        echo "Update Done"
    fi
    return $?
}

# Run update function with chosen package manager
updg $useSudo

# # Install necessary packages
if [ "$packageManager" = "apt" ]; then
    $useSudo "$packageManager"-get install -y cmake build-essential \
        git curl wget \
        apt-utils gettext file \
        bat exa
elif [ "$packageManager" = "pacman" ]; then
    $useSudo "$packageManager" -S --noconfirm base-devel \
        git curl wget \
        bat exa
fi

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installed successfully"
else
    echo "Failed to install"
fi
