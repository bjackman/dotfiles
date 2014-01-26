if [[ -n `grep "my_bashrc" ~/.bashrc` ]]; then
  echo "bashrc already source my_bashrc"
else
  echo "adding 'source ~/.my_bashrc' to ~/.bashrc"
  echo "source ~/.my_bashrc" >> ~/.bashrc
fi

function link {
  if [[ -e ~/$1 ]]; then
    echo "~/$1 already exists, could not create link"
  else
    echo "linking ~/$1 to ~/dotfiles/$1"
    ln -s ~/dotfiles/$1 ~/$1
  fi
}

for file in .my_bashrc .vimrc .gdbinit; do
  link $file
done

if [[ ! -x ~/bin/liquidprompt ]]; then
  echo "You need to install liquidprompt."
  echo "https://github.com/nojhan/liquidprompt"
fi
source ~/.bashrc
