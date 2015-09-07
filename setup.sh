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
    ln -vs ${dotfiles_dir}/${1#.} ~/$1
  fi
}

for file in .gitconfig .vimrc .gdbinit .config/sublime-text-3 .config/awesome \
    .conkyrc .screenrc .i3 .muttrc .emacs; do
  link $file
done

install_crontab() {
  crontab -r
  crontab ${dotfiles_dir}/cron.tab
  echo "Crontab installed."
}

echo "Installing crontab."
current_crontab=$(crontab -l)
if [ ! -z "$current_crontab" ]; then
  echo "A crontab is already installed:"
  echo
  crontab -l
  echo
  read -p "Delete crontab and install mine? [y/N]" DEL
  case "$DEL" in
    y|Y|yes ) install_crontab ;;
    * ) ;;
  esac
else
  install_crontab
fi

source ~/.bashrc
