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


nvim_setup() {
    local useSudo=$1

    if [ "$packageManager" = "apt" ]; then
        git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim
        cd /tmp/neovim && make -j 4 CMAKE_BUILD_TYPE=RelWithDebInfo
        cd build && cpack -G DEB && $useSudo dpkg -i nvim-linux64.deb

        if [ $? -eq 0 ]; then
            echo "NVIM installed"
        fi
    elif [ "$packageManager" = "pacman" ]; then
        $useSudo pacman -S --noconfirm neovim
        if [ $? -eq 0 ]; then
            echo "NVIM installed"
        fi
    fi
}


# Run update function with chosen package manager
updg $useSudo

# Run NVIM setup function with chosen package manager
nvim_setup $useSudo
