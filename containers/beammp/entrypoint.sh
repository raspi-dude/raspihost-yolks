#!/bin/bash
cd /home/container || exit 1

rm -f BeamMP-Server

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)
    MATCH="BeamMP-Server.alpine.x86_64"
    ;;
  aarch64)
    MATCH="BeamMP-Server.alpine.arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

echo "Downloading latest BeamMP server for architecture: $ARCH"

DOWNLOAD_URL=$(
  curl -fsSL https://api.github.com/repos/raspi-dude/BeamMP-Server-Alpine-Linux/releases/latest \
  | grep browser_download_url \
  | grep "$MATCH" \
  | head -n 1 \
  | cut -d '"' -f 4
)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Failed to find BeamMP binary."
    echo "Expected asset containing: $MATCH"
    exit 1
fi

curl -fsSL "$DOWNLOAD_URL" -o BeamMP-Server
chmod +x BeamMP-Server

MODIFIED_STARTUP=$(eval echo "$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")
echo ":/home/container$ ${MODIFIED_STARTUP}"

eval ${MODIFIED_STARTUP} 2>&1 | while IFS= read -r line; do
    echo "$line"
    
    if echo "$line" | grep -q "\[INFO\] Shutdown\." && ! echo "$line" | grep -q "\[CHAT\]"; then
        (sleep 2; pkill -9 -f "BeamMP-Server") &
    fi
done

exit 0
