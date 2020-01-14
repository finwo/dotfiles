#!/bin/sh
[ -z "$BASH_VERSION" ] && exec bash $0

# Make the cursor disappear when typing
if command -v xbanish &>/dev/null; then
  xbanish &
fi

# Add compositing support
if command -v xcompmgr &>/dev/null; then
  xcompmgr &
fi

# Custom key bindings
if command -v xbindkeys &>/dev/null; then
  xbindkeys
fi

# Safe settings
xsetroot -name ""
hasUsbcDisplay=2
xrandr --dpi 284 --fb 3840x2160 \
  --output DP-2 --panning 3840x2160 --scale 2x2 \
  --output DP-1 --off

# Xresources
if command -v xrdb &>/dev/null && [ -f ~/.Xresources ]; then
  xrdb ~/.Xresources
fi

# Wallpaper
if command -v feh &>/dev/null; then
  [ -f ~/pictures/wallpaper.png ] && feh --bg-fill ~/pictures/wallpaper.png
  while sleep 10; do
    [ -f ~/pictures/wallpaper.png ] && feh --bg-fill ~/pictures/wallpaper.png
  done &
fi

# Make repeating keys faster
if command -v xset &>/dev/null; then
  while sleep 10; do
    xset r rate 200 40
  done &
fi

while sleep 1; do
  XROOT=$(date +"%Y-%m-%d %H:%M")

  # Battery status
  if [ -d /sys/class/power_supply/BAT0 ]; then
    case "$(cat /sys/class/power_supply/AC/online)" in
      0)
        for cpu in `seq 0 11`; do
          echo "powersave" | tee /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor
        done &
        BATICO=""
        BATLEN="${#BATICO}"
        INDEX=$(( $(cat /sys/class/power_supply/BAT0/energy_now) * ${BATLEN} / $(cat /sys/class/power_supply/BAT0/energy_full) ))
        XROOT="${XROOT} ${BATICO:${INDEX}:1}"
        ;;
      1)
        for cpu in `seq 0 11`; do
          echo "performance" | tee /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor
        done &
        XROOT="${XROOT} "
        ;;
    esac
  fi

  # Set title
  xsetroot -name "${XROOT}"

  # # Detect DP-1 connected
  if xrandr | grep DP-1 | grep -v disconnected &>/dev/null; then
    if [ $hasUsbcDisplay -ne 1 ]; then
      hasUsbcDisplay=1
      xrandr --dpi 284 --fb 7680x2160 \
        --output DP-2 --panning 3840x2160+0+0 --scale 2x2 \
        --output DP-1 --mode 3840x2160 --pos 3840x0 --scale 1x1
    fi
  else
    if [ $hasUsbcDisplay -ne 0 ]; then
      hasUsbcDisplay=0
      xrandr --dpi 284 --fb 3840x2160 \
        --output DP-2 --panning 3840x2160 --scale 2x2 \
        --output DP-1 --off
    fi
  fi

done &

# window manager
while sleep 1; do dwm; done
