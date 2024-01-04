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

    return $?
}

add_google_chrome_repository "$useSudo"
