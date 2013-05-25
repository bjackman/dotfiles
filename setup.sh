if [[ -n `grep "my_bashrc" ~/.bashrc` ]]; then
  echo "bashrc already source my_bashrc"
else
  echo "adding 'source ~/.my_bashrc' to ~/.bashrc"
  echo "source ~/.my_bashrc" >> ~/.bashrc
fi

if [[ -e ~/.my_bashrc ]]; then
  echo "~/.my_bashrc already exists, could not create link"
else
  echo "linking ~/my_bashrc to ~/dotfiles/.my_bashrc"
  ln -s ~/dotfiles/.my_bashrc ~/.my_bashrc
fi
