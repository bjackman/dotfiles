#!/bin/bash

dotfiles_dir=$(readlink -f $(dirname $0))

if [[ -n `grep "${dotfiles_dir}/my_bashrc" ~/.bashrc` ]]; then
  echo "bashrc already sources my_bashrc"
else
  echo "adding 'source ${dotfiles_dir}/my_bashrc' to ~/.bashrc"
  echo "source ${dotfiles_dir}/my_bashrc" >> ~/.bashrc
fi

function link {
  if [[ -e ~/$1 ]]; then
    echo "~/$1 already exists, could not create link"
  else
    # ${foo#.} removes the '.' from the beginning of $foo
    ln -vs ${dotfiles_dir}/$(basename ${1#.}) ~/$1
  fi
}

for file in .gitconfig .vimrc muttrc .emacs .tmux.conf .config/sway .config/fish .config/just .hunspell_en_US; do
  link $file
done

source ~/.bashrc
