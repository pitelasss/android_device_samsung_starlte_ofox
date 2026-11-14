#!/system/bin/sh
# Charging LED in recovery (Samsung sec LED: /sys/class/sec/led/led_pattern)
# pattern: 0 = off, 1 = charging (red), 5 = fully charged (green)
LED=/sys/class/sec/led/led_pattern
BAT=/sys/class/power_supply/battery
[ -w "$LED" ] || { echo "led-charge: $LED not available" > /tmp/led-charge.log; exit 0; }
last=-1
while true; do
    st=$(cat $BAT/status 2>/dev/null)
    cap=$(cat $BAT/capacity 2>/dev/null)
    case "$st" in
        Full) p=5 ;;
        Charging) [ "$cap" = "100" ] && p=5 || p=1 ;;
        *) p=0 ;;
    esac
    if [ "$p" != "$last" ]; then
        echo $p > $LED && last=$p
    fi
    sleep 3
done
