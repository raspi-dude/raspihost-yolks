#!/bin/bash
cd /home/container

MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Watchdog: After 10 seconds of inactivity post-shutdown, force kill
(sleep 10; pkill -9 -f "BeamMP-Server") &
KILLER_PID=$!

eval ${MODIFIED_STARTUP}

# If server exits cleanly, kill the watchdog  
kill $KILLER_PID 2>/dev/null
exit 0
