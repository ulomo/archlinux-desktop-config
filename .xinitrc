#!/bin/sh

# usage: 
#   package: powertop,fcitx,picom,feh,polybar,redshift,xmonad should be installed firstly.
#   file:    .Xresources .Xmodmap ~/.config/polybar/config .xmonad/xmonad.hs needed
#   folder:  ~/Pictures/background
#   command: ~/.local/bin/mypowertop

# xterm theme and super key redefine
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap #caps to esc
xrdb -merge "$userresources"
xmodmap "$usermodmap"

for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
[ -x "$f" ] && . "$f"
done
unset f

# optimize power usage
sudo mypowertop &

# for xmonad
fcitx &
xinput | grep Touchpad | grep -E '=[0-9]{2}' -o | grep -E '[0-9]{2}' -o | xargs xinput disable #<disable touchpad>
picom -D 10 -f -r 8 -o 0.5 -b #<compositor>
while :;do feh --bg-scale "/home/narcissus/Pictures/background/`ls ~/Pictures/background/ | shuf -n1`";sleep 180;done & #<dynamic background>
xsetroot -cursor_name left_ptr #<setting cursor shap>
polybar mybar &>/dev/null & #<setting taskbar>
redshift & #<adjust color temperature>
exec xmonad

# for budgie-desktop
# export XDG_CURRENT_DESKTOP=Budgie:GNOME
# exec budgie-desktop

# for plasma-meta
#exec startplasma-x11
