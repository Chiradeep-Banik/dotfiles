#!/bin/sh

useSudo='sudo';

if [ "$(id -u)" -eq 0 ]; then
    useSudo=''
    source "/root/.bashrc"
else
    source "/home/$(whoami)/.bashrc"
fi

updg() {
    local useSudo=$1

    $useSudo apt-get update >/dev/null && $useSudo apt-get upgrade -y >/dev/null;
    if [ $? -eq 0 ]; then
        echo "Update Done"
    fi
    return $?
}

updg $useSudo

$useSudo apt-get install -y git vim curl wget > /dev/null

if [ $? -eq 0 ]; then
    echo "Installed successfully"
else
    echo "Failed to install"
fi

