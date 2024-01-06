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

nvim_setup() {
    local useSudo=$1

    git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim
    cd /tmp/neovim && make -j 4 CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build && cpack -G DEB && $useSudo sudo dpkg -i nvim-linux64.deb
    
    if [[ $? -eq 0 ]]; then
        echo "NVIM installed"
    fi

}

updg $useSudo

nvim_setupi $useSudo
