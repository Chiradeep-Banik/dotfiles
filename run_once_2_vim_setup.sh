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

vim_setup() {
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim -es -u ~/.vimrc +PlugInstall +qa
}

updg $useSudo

$useSudo echo "185.199.108.133 raw.githubusercontent.com" >> /etc/hosts 

vim_setup