#!/bin/bash
# Получаем нагрузку на каждое ядро через mpstat (нужен пакет sysstat)
cores=$(mpstat -P ALL 1 1 | awk '/Average:/ && $2 ~ /[0-9]/ {printf "Core %s: %s%%\n", $2, $3}')
total=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

echo "{\"text\": \"  ${total%.*}\%\", \"tooltip\": \"$cores\"}"
