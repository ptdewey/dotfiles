# Start pywal on boot
wal -R

xset +fp /home/patrick/.fonts
xset +fp /home/patrick/.local/share/fonts
xset fp rehash

setxkbmap -option caps:escape

xset r rate 100 50 

system76-power profile battery

xrandr --dpi 192

xrdb ~/.Xresources

