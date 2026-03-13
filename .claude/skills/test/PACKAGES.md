---
requires_approval: false
pre_actions:
  - use: upgrade
---
# Packages

Apply package changes.

**All commands must use `work_dir: /tmp/chain-manager`** — this is the root of the chain-ops repository.

## Steps

1. Verify the service is running
2. Verify the current block height
3. Preview changes
4. Apply changes
5. Verify the service is running
6. Verify block height is increasing (may require querying multiple times)

```bash
# Preview changes
just play test.yml packages.yml -l <network/server> -u sol -CD

# Apply changes
just play test.yml packages.yml -l <network/server> -u sol

# Check service is running
just cmd test.yml <network/server> "sudo systemctl status ssh"

# Check block height (run two or three times to confirm it's increasing)
just cmd test.yml <network/server> "curl http://localhost:8888"
```
