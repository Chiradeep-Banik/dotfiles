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
        $useSudo "apt-get" update && $useSudo "apt-get" upgrade -y
    elif [ "$packageManager" = "pacman" ]; then
        $useSudo "pacman" -Syu
    fi

    if [ $? -eq 0 ]; then
        echo "Update Done"
    fi
    return $?
}


nvim_setup() {
    local useSudo=$1

    if [ "$packageManager" = "apt" ]; then
        echo "Setting up NVIM on Debian-based system..."
        echo "Installing build dependencies..."
        $useSudo apt-get update
        $useSudo apt-get install -y --no-install-recommends \
            cmake ninja-build build-essential \
            libtool pkg-config python3-dev \
            ruby-dev liblua5.1-0-dev gettext

        if [ $? -ne 0 ]; then
            echo "Error installing build dependencies. NVIM setup failed."
            return 1
        fi

        echo "Cloning Neovim repository..."
        if ! git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim; then
            echo "Error cloning Neovim repository. NVIM setup failed."
            return 1
        fi

        cd /tmp/neovim

        echo "Creating build directory..."
        mkdir build
        cd build

        echo "Configuring build..."
        if ! cmake -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/usr ..; then
            echo "Error configuring build. NVIM setup failed."
            return 1
        fi

        echo "Building Neovim..."
        if ! ninja -j "$(nproc)"; then
            echo "Error building Neovim. NVIM setup failed."
            return 1
        fi

        echo "Installing Neovim..."
        if ! $useSudo ninja install; then
            echo "Error installing Neovim. NVIM setup failed."
            return 1
        fi

        echo "NVIM installed successfully!"

    elif [ "$packageManager" = "pacman" ]; then
        echo "Setting up NVIM on Arch-based system..."
        echo "Installing Neovim from pacman..."
        if ! $useSudo pacman -S --noconfirm neovim; then
            echo "Error installing NVIM from pacman."
            return 1
        fi
        echo "NVIM installed successfully!"
    fi
}


# Run update function with chosen package manager
updg $useSudo

# Run NVIM setup function with chosen package manager
nvim_setup $useSudo

# Install necessary packages
if [ "$packageManager" = "apt" ]; then
    echo "Installing additional packages for Debian-based system..."
    $useSudo apt-get install -y cmake build-essential \
        git curl wget \
        apt-utils gettext file \
        bat exa zoxide
elif [ "$packageManager" = "pacman" ]; then
    echo "Installing additional packages for Arch-based system..."
    $useSudo pacman -S --noconfirm base-devel \
        git curl wget \
        bat exa zoxide
fi

# Add the smartcam executable to binary for droidcam setup
if [ -f /home/banik/.config/smartcam/smartcam ]; then
    echo "Copying smartcam executable..."
    $useSudo cp /home/banik/.config/smartcam/smartcam /usr/local/bin/.
else
    echo "Warning: smartcam executable not found at /home/banik/.config/smartcam/smartcam"
fi

# Check if installation was successful
if [ $? -eq 0 ]; then
    echo "Installed successfully"
else
    echo "Failed to install"
fi