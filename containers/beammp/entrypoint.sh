#!/bin/bash
cd /home/container

echo "testing wsg guys"

# Replace Startup Variables
MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP} &
SERVER_PID=$!

# Wait for the server process
wait $SERVER_PID

# After BeamMP "exits" (but hangs), give it 5 seconds then force kill
sleep 5
kill -9 $SERVER_PID 2>/dev/null

echo "Server exited with code 0"
exit 0
