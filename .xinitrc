#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap #caps to esc
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

export PATH=$PATH:~/.local/bin:~/Software/go/bin
# merge in defaults and keymaps
#if [ -f $sysresources ]; then
#    xrdb -merge $sysresources
#fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#own command optimize power usage
    sudo mypowertop &>/dev/null & 

# for xmonad
    fcitx &
    xinput | grep Touchpad | grep -E '=[0-9]{2}' -o | grep -E '[0-9]{2}' -o | xargs xinput disable
    picom -D 10 -f -r 8 -o 0.5 -b
    while :;do feh --bg-scale "/home/narcissus/Pictures/background/`ls ~/Pictures/background/ | shuf -n1`";sleep 180;done &
    xsetroot -cursor_name left_ptr #<setting cursor shap>
    polybar mybar &>/dev/null & #<setting taskbar>
    redshift &
    exec xmonad

# for budgie-desktop
   # export XDG_CURRENT_DESKTOP=Budgie:GNOME
   # exec budgie-desktop
# for plasma-meta
   #exec startplasma-x11
