#!/bin/bash
cd /home/container

echo "testing wsg guys"

# Replace Startup Variables
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run server in background
${MODIFIED_STARTUP} &
SERVER_PID=$!

# Wait for up to 5 seconds after the wait command
timeout 5s bash -c "wait $SERVER_PID" 2>/dev/null || kill -9 $SERVER_PID 2>/dev/null

echo "BeamMP process ended, script exiting..."
