dotfiles_dir=$(readlink -f $(dirname $0))

if [[ -n `grep "my_bashrc" ~/.bashrc` ]]; then
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

for file in .vimrc .gdbinit .config/sublime-text-3 .config/awesome; do
link $file
done

mkdir -vp ~/bin

#TODO probably need to `git submodule init` or something
if [[ ! -x ~/bin/liquidprompt ]]; then
  ln -s ${dotfiles_dir}/liquidprompt/liquidprompt ~/bin/liquidprompt 
fi

source ~/.bashrc
