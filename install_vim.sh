#! /bin/bash

stage=1
stop_stage=1000

. ./parse_options.sh

[ -z `which vim` ] && echo "install vim" && exit 1
[ -z `which curl` ] && echo "install curl" && exit 1
[ -z `which cmake` ] && echo "install cmake" && exit 1

if [ $stage -le 0 ] && [ $stop_stage -ge 0 ]; then
    apt-get update
    apt-get install vim git curl
fi

if [ $stage -le 1 ] && [ $stop_stage -ge 1 ]; then
    echo "Download vimrc"
    curl -LO https://raw.githubusercontent.com/lalq/Dev/master/.vimrc
    cp .vimrc ~
fi

if [ $stage -le 2 ] && [ $stop_stage -ge 2 ]; then
    cd ~
    if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    vim -c 'PluginInstall' -c 'qa!'
fi

if [ $stage -le 3 ] && [ $stop_stage -ge 3 ]; then
    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    python3 install.py
    cd ~
fi
