# Troubleshooting

## Status Checks

```bash
# Check block height
curl -s http://<host>.tail46463.ts.net:8888/

# Service status
ssh sol@<host>.tail46463.ts.net "sudo systemctl status sshd"

# Recent logs
ssh sol@<host>.tail46463.ts.net "sudo journalctl -u sshd -n 100"

# Follow logs live
ssh sol@<host>.tail46463.ts.net "sudo journalctl -u sshd -f"
```

Or via `just`:

```bash
# Check block height (run two or three times to confirm it's increasing)
just cmd test.yml <network/server> "curl http://localhost:8888"

# Check service status
just cmd test.yml <network/server> "sudo systemctl status ssh"
```

## Monitoring

Test blockchain exposes RPC on port 8888.

```bash
curl -s http://<host>.tail46463.ts.net:8888/
```
