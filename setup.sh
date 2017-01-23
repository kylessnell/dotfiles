#!/usr/bin/env bash

if [ ! -e ~/.vim/autoload/plug.vim ]; then
  echo "installing plug for vim packages"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

cwd=`pwd`
echo "creating symlinks"
for file in vimrc tmux.conf zshrc aliasrc; do
  echo " * $file"
  ln -sf $cwd/$file $HOME/.$file
done
