#!/usr/bin/env bash
# Check DNS through the system resolver and optionally dig.
set -u
HOST="${1:-example.com}"
echo "DNS check for: $HOST"
echo "Timestamp: $(date -Is)"
echo
echo "== getent =="
if getent ahosts "$HOST"; then
  echo "[PASS] System resolver returned address(es)."
else
  echo "[FAIL] System resolver did not return addresses."
fi
if command -v dig >/dev/null 2>&1; then
  echo
  echo "== dig =="
  dig +time=2 +tries=1 "$HOST"
else
  echo "dig is not installed. On Ubuntu: sudo apt install dnsutils"
fi
