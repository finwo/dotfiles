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

# Custom key bindings
if command -v xbindkeys &>/dev/null; then
  xbindkeys
fi

xsetroot -name ""
while sleep 10; do
  XROOT=$(date +"%Y-%m-%d %H:%M")

  # Battery status
  if [ -d /sys/class/power_supply/BAT0 ]; then
    case "$(cat /sys/class/power_supply/AC/online)" in
      0)
        BATICO=""
        BATLEN="${#BATICO}"
        INDEX=$(( $(cat /sys/class/power_supply/BAT0/energy_now) * ${BATLEN} / $(cat /sys/class/power_supply/BAT0/energy_full) ))
        XROOT="${XROOT} ${BATICO:${INDEX}:1}"
        ;;
      1)
        XROOT="${XROOT} "
        ;;
    esac
  fi

  # Make repeating keys faster
  if command -v xset &>/dev/null; then
    xset r rate 200 40
  fi

  xsetroot -name "${XROOT}"
done &
  # TODO: discharching charmap
  # TODO: index = charge_full * (BATSTATE.length-1) / charge_now
  # TODO: XROOT += BATSTATE[index]

# window manager
while sleep 1; do dwm; done
