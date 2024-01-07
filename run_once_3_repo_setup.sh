#!/bin/sh

useSudo='sudo'

if [ "$(id -u)" -eq 0 ]; then
    useSudo=''
fi

updg() {
    local useSudo=$1

    $useSudo apt-get update >/dev/null && $useSudo apt-get upgrade -y >/dev/null;
    if [ $? -eq 0 ]; then
        echo "Update Done"
    fi
    return $?
}

add_google_chrome_repository() {
    local useSudo=$1
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
                echo "Installed google-chrome-stable"
            else
                echo "Failed to install google-chrome-stable"
            fi
            ;;
        [nN]|[nN][oO])
            echo "Okk.. Not installing Google-Chome-stable"
            ;;
        *)
            echo "Invalid response. Please enter 'y' for Yes or 'n' for No."
            ;;
    esac

    return $?
}

ask_to_install_docker() {
    local question="Install Docker"
    local useSudo=$1

    read -p "$question (y/n): " response

    # Check the user's response
    case "$response" in
        [yY]|[yY][eE][sS])
            curl -fsSL https://get.docker.com -o get-docker.sh
            $useSudo chmod +x get-docker.sh
            $useSudo ./get-docker.sh
            $useSudo rm -f get-docker.sh
            if [ $? -eq 0 ]; then
                echo "Installed Docker"
            else
                echo "Failed to install docker"
            fi
            ;;
        [nN]|[nN][oO])
            echo "Okk.. Not installing docker"
            ;;
        *)
            echo "Invalid response. Please enter 'y' for Yes or 'n' for No."
            ;;
    esac
}

add_vscode_repository() {
    local useSudo=$1
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

    local question="Install Vscode "
    read -p "$question (y/n): " response

    # Check the user's response
    case "$response" in
        [yY]|[yY][eE][sS])
            $useSudo apt-get install -y apt-transport-https > /dev/null
            $useSudo apt-get install -y code-insiders > /dev/null
            if [ $? -eq 0 ]; then
                echo "Installed vscode"
            else
                echo "Failed to install vscode"
            fi
            ;;
        [nN]|[nN][oO])
            echo "Okk...Not installing vscode"
            ;;
        *)
            echo "Invalid response. Please enter 'y' for Yes or 'n' for No."
            ;;
    esac

    updg $useSudo

    return $?
}

add_google_chrome_repository "$useSudo"

add_vscode_repository "$useSudo"

ask_to_install_docker "$useSudo"
