---
requires_approval: false
pre_actions:
  - use: upgrade
---
# Upgrades

Apply config changes or upgrade to a new version.

**All commands must use `work_dir: /tmp/chain-manager`** — this is the root of the chain-ops repository.

## Steps

1. Update `test_version` in `ansible/inventories/group_vars/<network>/test.yml`
2. Verify the service is running
3. Verify the current block height
4. Preview changes
5. Apply changes
6. Verify the service is running
7. Verify block height is increasing (may require querying multiple times)

```bash
# Preview changes
just play test.yml upgrade.yml -l <network/server> -u sol -CD

# Apply changes
just play test.yml upgrade.yml -l <network/server> -u sol

# Check service is running
just cmd test.yml <network/server> "sudo systemctl status ssh"

# Check block height (run two or three times to confirm it's increasing)
just cmd test.yml <network/server> "curl http://localhost:8888"
```
