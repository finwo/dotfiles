#!/bin/sh
[ -z "$BASH_VERSION" ] && exec bash $0

# wallpaper
if command -v feh &>/dev/null; then
  [ -f ~/pictures/wallpaper.png ] && feh --bg-scale ~/pictures/wallpaper.png
fi

# Make the cursor disappear when typing
if command -v xbanish &>/dev/null; then
  xbanish &
fi

# Make repeating keys faster
if command -v xset &>/dev/null; then
  while sleep 60; do
    xset r rate 200 40
  done &
fi

# window manager
while sleep 1; do dwm; done
