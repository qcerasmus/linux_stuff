#! /bin/bash

#install vim plug
FILE=~/.vim/autoload/plug.vim
if [ ! -f "$FILE" ]; then
  echo "downloading vim plugin manager"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
cp vim/vimrc ~/.vimrc

