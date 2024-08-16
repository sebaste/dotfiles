[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

exec xmonad
