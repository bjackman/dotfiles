set -u

xset m 4 4	 # Set mouse sensitivity
awsetbg -c ~/.config/awesome/Earth-terminator.jpg

pgrep conky > /dev/null || conky&
pgrep nm-applet > /dev/null || nm-applet&

hostname | grep desktop > /dev/null && setxkbmap gb

SpiderOak&
