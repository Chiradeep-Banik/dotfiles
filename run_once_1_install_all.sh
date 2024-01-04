#!/bin/sh

useSudo='sudo';

path='.local/share/chezmoi/run_once_0_function.sh';

user=$(whoami)

if [ "$(id -u)" -eq 0 ]; then
    useSudo=''
    path='/root/.local/share/chezmoi/run_once_0_function.sh'
else    
    path="/home/$user/.local/share/chezmoi/run_once_0_function.sh"
fi

source $path

updg $useSudo

$useSudo apt-get install -y git vim curl wget > /dev/null

if [ $? -eq 0 ]; then
    echo "Installed successfully"
else
    echo "Failed to install"
fi

source ~/.bashrc
