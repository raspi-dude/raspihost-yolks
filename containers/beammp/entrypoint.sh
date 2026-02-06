#!/bin/bash
cd /home/container

MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run BeamMP and pipe output through a monitor
eval ${MODIFIED_STARTUP} 2>&1 | while IFS= read -r line; do
    echo "$line"
    
    # When we see "Shutdown." in the output, kill BeamMP after 2 seconds
    if echo "$line" | grep -q "Shutdown\."; then
        (sleep 2; pkill -9 -f "BeamMP-Server") &
    fi
done

exit 0
