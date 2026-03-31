#!/bin/bash
# Polybar status color: green/orange/red based on thresholds
# Usage: status-color.sh <metric>

GREEN="#50FA7B"
ORANGE="#FFB86C"
RED="#FF5555"
FG="#F8F8F2"

colorize() {
    local val=$1 warn=$2 crit=$3 label=$4 value=$5
    local color
    if (( val >= crit )); then
        color=$RED
    elif (( val >= warn )); then
        color=$ORANGE
    else
        color=$GREEN
    fi
    if [[ -n "$label" ]]; then
        echo "%{F$FG}${label}%{F-} %{F${color}}${value}%{F-}"
    else
        echo "%{F${color}}${value}%{F-}"
    fi
}

case "$1" in
    cpu)
        read -r _ a1 b1 c1 d1 rest < /proc/stat
        sleep 0.2
        read -r _ a2 b2 c2 d2 rest < /proc/stat
        total=$(( (a2+b2+c2+d2) - (a1+b1+c1+d1) ))
        idle=$(( d2 - d1 ))
        if (( total > 0 )); then
            usage=$(( 100 * (total - idle) / total ))
        else
            usage=0
        fi
        colorize $usage 60 85 $'\xef\x8b\x9b' "${usage}%"
        ;;
    memory)
        pct=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
        colorize "$pct" 70 90 $'\xef\x82\xae' "${pct}%"
        ;;
    disk)
        pct=$(df / | awk 'NR==2 {gsub(/%/,""); print $5}')
        colorize "$pct" 70 90 $'\xef\x82\xa0' "${pct}%"
        ;;
    cpu-temp)
        temp_raw=$(cat /sys/class/hwmon/hwmon5/temp1_input)
        temp=$(( temp_raw / 1000 ))
        colorize $temp 65 80 "" "${temp}°C"
        ;;
    gpu-temp)
        temp_raw=$(cat /sys/class/hwmon/hwmon7/temp1_input)
        temp=$(( temp_raw / 1000 ))
        colorize $temp 70 85 "GPU" "${temp}°C"
        ;;
esac
