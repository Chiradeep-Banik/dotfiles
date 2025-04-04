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

build_yay() {
    local useSudo=$1

    if [ "$packageManager" = "pacman" ]; then
        # Check if yay is already installed
        if command -v yay &> /dev/null; then
            echo "Yay is already installed."
            return 0
        fi

        # Install git if not already installed
        if ! command -v git &> /dev/null; then
            echo "Git is not installed. Installing..."
            $useSudo pacman -S --noconfirm git
            if [ $? -ne 0 ]; then
                echo "Failed to install git. Cannot install yay."
                return 1
            fi
        fi

        # Install base-devel if not already installed (recommended for AUR builds)
        if ! pacman -Qg base-devel > /dev/null; then
            echo "base-devel is not installed. Installing..."
            $useSudo pacman -S --noconfirm base-devel
            if [ $? -ne 0 ]; then
                echo "Failed to install base-devel. Cannot install yay."
                return 1
            fi
        fi

        # Clone yay repository
        git clone https://aur.archlinux.org/yay.git /tmp/yay

        # Build and install yay
        cd /tmp/yay
        makepkg -si --noconfirm

        if [ $? -eq 0 ]; then
            echo "Yay installed"
        else
            echo "Failed to install Yay"
        fi
    fi
}

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

install_google_chrome() {
    local useSudo=$1

    # Ask user if they want to install Google Chrome
    local question="Install Google Chrome"
    read -p "$question (y/n): " response

    # Check the user's response
    case "$response" in
        [yY]|[yY][eE][sS])
            if [ "$packageManager" = "apt" ]; then
                $useSudo curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | $useSudo gpg --dearmor | $useSudo tee /usr/share/keyrings/google-chrome.gpg >> /dev/null

                $useSudo echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | $useSudo tee /etc/apt/sources.list.d/google-chrome.list

                if [ $? -eq 0 ]; then
                    echo "Added Google Chrome repository"
                else
                    echo "Failed to add Google Chrome repository"
                fi

                updg $useSudo
                local question="Install Google Chrome "

                read -p "$question (y/n): " response

                # Check the user's response
                case "$response" in
                    [yY]|[yY][eE][sS])
                        $useSudo apt-get install -y google-chrome-stable > /dev/null
                        if [ $? -eq 0 ]; then
                            echo "Installed Google Chrome"
                        else
                            echo "Failed to install Google Chrome"
                        fi
                        ;;
                    [nN]|[nN][oO])
                        echo "Skipping installation of Google Chrome"
                        ;;
                    *)
                        echo "Invalid response. Please enter 'y' for Yes or 'n' for No."
                        ;;
                esac
            elif [ "$packageManager" = "pacman" ]; then
                $useSudo yay -S --noconfirm google-chrome

                if [ $? -eq 0 ]; then
                    echo "Installed Google Chrome"
                else
                    echo "Failed to install Google Chrome"
                fi
            fi
            ;;
        [nN]|[nN][oO])
            echo "Skipping installation of Google Chrome"
            ;;
        *)
            echo "Invalid response. Please enter 'y' for Yes or 'n' for No."
            ;;
    esac
}


install_vscode() {
    local useSudo=$1

    # Ask user if they want to install VSCode
    local question="Install VSCode"
    read -p "$question (y/n): " response

    # Check the user's response
    case "$response" in
        [yY]|[yY][eE][sS])
            if [ "$packageManager" = "apt" ]; then
                $useSudo apt-get install -y wget gpg > /dev/null
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                $useSudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
                $useSudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
                rm -f packages.microsoft.gpg
                updg $useSudo
                if [ $? -eq 0 ]; then
                    echo "Added vscode repository"
                else
                    echo "Failed to add vscode repository"
                fi
                $useSudo apt-get install -y apt-transport-https > /dev/null
                $useSudo apt-get install -y code > /dev/null
            elif [ "$packageManager" = "pacman" ]; then
                $useSudo yay -S --noconfirm visual-studio-code-bin
            fi

            if [ $? -eq 0 ]; then
                echo "Installed VSCode"
            else
                echo "Failed to install VSCode"
            fi
            ;;
        [nN]|[nN][oO])
            echo "Skipping installation of VSCode"
            ;;
        *)
            echo "Invalid response. Please enter 'y' for Yes or 'n' for No."
            ;;
    esac
}


install_docker() {
    local question="Install Docker"
    local useSudo=$1

    read -p "$question (y/n): " response

    # Check the user's response
    case "$response" in
        [yY]|[yY][eE][sS])
            if [ "$packageManager" = "apt" ]; then
                curl -fsSL https://get.docker.com -o get-docker.sh
                $useSudo chmod +x get-docker.sh
                $useSudo ./get-docker.sh
                $useSudo rm -f get-docker.sh
            elif [ "$packageManager" = "pacman" ]; then
                $useSudo pacman -S --noconfirm docker
            fi
            if [ $? -eq 0 ]; then
                echo "Installed Docker"
            else
                echo "Failed to install Docker"
            fi
            ;;
        [nN]|[nN][oO])
            echo "Okk.. Not installing Docker"
            ;;
        *)
            echo "Invalid response. Please enter 'y' for Yes or 'n' for No."
            ;;
    esac
}



# Check if it is a Docker environment
read -p "Is it a Docker environment? (y/n): " dockerEnvironment

if [ "$dockerEnvironment" = "y" ]; then
    echo "Running in a Docker environment. Skipping user prompts for yay, Chrome, VSCode, and Docker."
else
    build_yay "$useSudo"
    install_google_chrome "$useSudo"
    install_vscode "$useSudo"
    install_docker "$useSudo"
fi