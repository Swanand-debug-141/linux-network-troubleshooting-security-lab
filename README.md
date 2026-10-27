# Linux Network Troubleshooting & Security Lab

A hands-on Ubuntu lab for practicing core Linux networking checks and building a repeatable troubleshooting workflow. The scripts are designed to **inspect and report**; they do not change network or firewall settings.

## Contents

```text
linux-network-troubleshooting-security-lab/
├── README.md
├── .gitignore
├── scripts/
│   ├── network_diagnostics.sh
│   ├── check_dns.sh
│   └── capture_dns.sh
├── reports/
│   └── sample-report-template.md
└── images/
    └── add-your-own-screenshot.png
```

## Features

- Interface and IP address inspection
- Routing table review
- Basic reachability test
- DNS resolution check using `getent` and optional `dig`
- Listening socket inspection with `ss`
- SSH service status check
- UFW firewall status check when available
- Timestamped text report
- Optional, short DNS packet capture with `tcpdump`

## Requirements

Recommended environment: Ubuntu Linux VM or a Linux machine you administer.

```bash
sudo apt update
sudo apt install -y iproute2 iputils-ping dnsutils tcpdump ufw openssh-server
```

`dnsutils`, `tcpdump`, `ufw`, and `openssh-server` are optional if you only want to run the core diagnostics.

## Run the diagnostics

From the repository root:

```bash
chmod +x scripts/*.sh
./scripts/network_diagnostics.sh
```

Optional custom reachability target and DNS hostname:

```bash
./scripts/network_diagnostics.sh 1.1.1.1 example.com
```

Run only the DNS check:

```bash
./scripts/check_dns.sh example.com
```

Optional DNS capture (requires `tcpdump` and usually `sudo`):

```bash
sudo ./scripts/capture_dns.sh
```

The capture is limited to 15 seconds and is saved under `/tmp`. Do not commit packet captures: they can contain sensitive metadata.

## Example output

The following is **illustrative sample output** to show the format. It is not a result collected from your computer. Actual IP addresses, routes, ports, DNS answers, and service states will vary by environment.

```text
Linux Network Troubleshooting Report
Timestamp: 2026-10-27T20:15:00+05:30
Hostname: ubuntu-lab
Kernel: Linux 6.8.0-generic

===== Interface addresses =====
lo               UNKNOWN        127.0.0.1/8 ::1/128
ens33            UP             192.168.1.105/24 fe80::abcd/64

===== Routing table =====
default via 192.168.1.1 dev ens33 proto dhcp
192.168.1.0/24 dev ens33 proto kernel scope link src 192.168.1.105

===== Reachability: 1.1.1.1 =====
2 packets transmitted, 2 received, 0% packet loss

===== DNS resolution: example.com =====
93.184.216.34 STREAM example.com
93.184.216.34 DGRAM
93.184.216.34 RAW

===== Listening sockets =====
Netid State  Recv-Q Send-Q Local Address:Port Peer Address:Port
tcp   LISTEN 0      128    0.0.0.0:22       0.0.0.0:*

===== SSH service =====
active

===== UFW status =====
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)

===== End of report =====
Report saved to: reports/network-report-20261027_201500.txt
```


## Troubleshooting workflow

| Step | Command | What it helps check |
|---|---|---|
| 1 | `ip -brief address` | Interface state and assigned addresses |
| 2 | `ip route` | Routes and default gateway |
| 3 | `ping -c 2 1.1.1.1` | Basic reachability; ICMP may be blocked |
| 4 | `getent ahosts example.com` | System DNS resolution |
| 5 | `ss -tuln` | Listening TCP/UDP sockets |
| 6 | `systemctl is-active ssh` | SSH service state; some systems use `sshd` |
| 7 | `sudo ufw status verbose` | UFW firewall policy, if installed |

## Example test cases

| Test | How to run | Expected observation |
|---|---|---|
| Interface inspection | `ip -brief address` | Lists interfaces and assigned addresses |
| Route inspection | `ip route` | Shows routes known to the kernel |
| DNS check | `./scripts/check_dns.sh example.com` | Displays resolved addresses if DNS works |
| Listening sockets | `ss -tuln` | Lists local listening sockets |
| SSH service | `systemctl is-active ssh` | Prints `active` if the `ssh` service is active |
| Firewall status | `sudo ufw status verbose` | Displays UFW state if UFW is installed |

## Safety and privacy

- Run this only on machines and networks you own or are authorized to troubleshoot.
- Packet captures and diagnostic reports may reveal hostnames, IP addresses, and network details.
- Review and redact output before publishing it publicly.
- The scripts do not automatically fix network issues or change firewall policy.

## Future improvements

- Add JSON output for integration with other tools.
- Add HTTP endpoint and port-connectivity checks.
- Add latency sampling and simple threshold alerts.
- Include real sanitized screenshots and a completed troubleshooting case study.

## Resume note

After running the lab and adding your own tests, you can describe the work accurately as a Linux networking lab covering interface/routing checks, DNS resolution, socket inspection, SSH status, firewall review, and diagnostic report generation. Do not claim uptime improvements or measured incident reductions unless you have evidence.
