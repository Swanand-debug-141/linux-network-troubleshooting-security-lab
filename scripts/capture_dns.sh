#!/usr/bin/env bash
# Optional short DNS capture. Requires tcpdump and usually sudo.
set -u
if ! command -v tcpdump >/dev/null 2>&1; then
  echo "tcpdump is not installed. On Ubuntu: sudo apt install tcpdump"
  exit 1
fi
OUT="/tmp/dns-capture-$(date +%Y%m%d_%H%M%S).pcap"
echo "Capturing DNS traffic for up to 15 seconds."
echo "Output: $OUT"
echo "Only capture systems/networks you are authorized to inspect."
sudo timeout 15 tcpdump -ni any -w "$OUT" 'port 53'
STATUS=$?
if [ -f "$OUT" ]; then
  echo "Capture saved: $OUT"
  echo "Review locally with: sudo tcpdump -nn -r \"$OUT\""
else
  echo "No capture file was created."
fi
if [ "$STATUS" -eq 124 ]; then
  echo "Capture completed after the 15-second timeout."
fi
