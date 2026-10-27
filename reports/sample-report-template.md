# Network Troubleshooting Findings

Replace this template with observations from your own lab. Redact sensitive hostnames, IPs, usernames, and captures before publishing.

- **Date/time:**
- **Environment:** Ubuntu VM / host-only lab / other
- **Issue or test scenario:**
- **Expected behavior:**
- **Observed behavior:**

## Evidence

| Check | Command | Result |
|---|---|---|
| Interface and IP | `ip -brief address` | |
| Routes | `ip route` | |
| Reachability | `ping -c 2 <approved-host>` | |
| DNS | `getent ahosts example.com` | |
| Listening ports | `ss -tuln` | |
| SSH service | `systemctl is-active ssh` | |
| Firewall | `sudo ufw status verbose` | |

## Diagnosis
- **Likely cause:**
- **Evidence supporting it:**
- **Fix or next test:**
- **Validation after the fix:**
- **What I learned:**
