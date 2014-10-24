set -eu

setxkbmap gb # Set keyboard map
xset m 4 4	 # Set mouse sensitivity
awsetbg -c ~/.config/awesome/Earth-terminator.jpg

pgrep conky > /dev/null || conky
pgrep nm-applet > /dev/null || nm-applet
