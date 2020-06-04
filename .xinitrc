#!/bin/sh

# usage: 
#   package: powertop,fcitx,picom,feh,polybar,redshift,xmonad,xorg-xinput should be installed firstly.
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
redshift -r -t 5200:3800 &>/dev/null & #<adjust color temperature>
fcitx &
xinput | grep Touchpad | grep -E '=[0-9]{2}' -o | grep -E '[0-9]{2}' -o | xargs xinput disable #<disable touchpad>
picom --experimental-backends --config .config/picom/picom.conf &>/dev/null &
while :;do feh -D 0.3 -z --bg-scale ~/Pictures/background/;sleep 180;done & #<dynamic background>
xsetroot -cursor_name left_ptr #<setting cursor shap>
polybar -q mybar &>/dev/null & #<setting taskbar>
exec xmonad

# for budgie-desktop
# export XDG_CURRENT_DESKTOP=Budgie:GNOME
# exec budgie-desktop

# for plasma-meta
#exec startplasma-x11
