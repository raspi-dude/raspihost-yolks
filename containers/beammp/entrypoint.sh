#!/bin/bash
cd /home/container

MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo ":/home/container$ ${MODIFIED_STARTUP}"

eval ${MODIFIED_STARTUP} 2>&1 | while IFS= read -r line; do
    echo "$line"
    
    if echo "$line" | grep -q "\[INFO\] Shutdown\." && ! echo "$line" | grep -q "\[CHAT\]"; then
        (sleep 2; pkill -9 -f "BeamMP-Server") &
    fi
done

exit 0
