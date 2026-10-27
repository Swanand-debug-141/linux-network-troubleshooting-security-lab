#!/usr/bin/env bash
# Read-only Linux network diagnostics; this script does not change system settings.
set -u
PING_TARGET="${1:-1.1.1.1}"
DNS_TARGET="${2:-example.com}"
STAMP="$(date +%Y%m%d_%H%M%S)"
REPORT_DIR="reports"
REPORT_FILE="${REPORT_DIR}/network-report-${STAMP}.txt"
mkdir -p "$REPORT_DIR"

{
  echo "Linux Network Troubleshooting Report"
  echo "Timestamp: $(date -Is)"
  echo "Hostname: $(hostname)"
  echo "Kernel: $(uname -sr)"
  echo
  echo "===== Interface addresses ====="
  ip -brief address 2>&1 || true
  echo
  echo "===== Routing table ====="
  ip route 2>&1 || true
  echo
  echo "===== Reachability: ${PING_TARGET} ====="
  ping -c 2 -W 2 "$PING_TARGET" 2>&1 || echo "[INFO] Ping failed or ICMP may be filtered."
  echo
  echo "===== DNS resolution: ${DNS_TARGET} ====="
  getent ahosts "$DNS_TARGET" 2>&1 || echo "[INFO] Name resolution failed."
  if command -v dig >/dev/null 2>&1; then
    echo
    echo "===== dig summary ====="
    dig +time=2 +tries=1 "$DNS_TARGET" 2>&1 || true
  else
    echo "[INFO] dig not installed; skipped."
  fi
  echo
  echo "===== Listening sockets ====="
  ss -tuln 2>&1 || true
  echo
  echo "===== SSH service ====="
  if command -v systemctl >/dev/null 2>&1; then
    systemctl is-active ssh 2>&1 || systemctl is-active sshd 2>&1 || echo "[INFO] SSH inactive or service name differs."
  else
    echo "[INFO] systemctl unavailable."
  fi
  echo
  echo "===== UFW status ====="
  if command -v ufw >/dev/null 2>&1; then
    sudo ufw status verbose 2>&1 || echo "[INFO] Could not read UFW status."
  else
    echo "[INFO] UFW not installed."
  fi
  echo
  echo "===== End of report ====="
} | tee "$REPORT_FILE"

echo
echo "Report saved to: $REPORT_FILE"
