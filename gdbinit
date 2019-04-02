# Lets you have a .gdbinit in each project directory.
# Be careful, I guess.
set auto-load safe-path /

set prompt \033[1m \033[31mgdb $ \033[0m
set output-radix 0x10

set print pretty on

macro define offsetof(_type, _memb) ((long)(&((_type *)0)->_memb))
macro define container_of(_ptr, _type, _memb) ((_type *)((void *)(_ptr) - offsetof(_type, _memb)))

# source ~/dotfiles/colors.gdb

