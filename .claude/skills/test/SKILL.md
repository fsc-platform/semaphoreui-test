---
requires_approval: false
pre_actions:
  - use: upgrade
---

# Test Blockchain Management

Manage Test Blockchain validators and core clients across mainnet, and testnet networks.

## Quick Reference

| Task | Action |
|------|--------|
| Check logs | `ssh sol@<host>.tail46463.ts.net "sudo journalctl -u ssh -f"` |
| Check sync | `curl -s http://<host>.tail46463.ts.net:8888/` |
| Preview changes | Add `-CD` flag to any playbook |
| Limit to network | Add `-l mainnet` (or testnet) |

## Slack Message Format

You will receive messages from Slack in the following formats and here is what you need to run:

Message: <action/playbook> <blockchain> <network> <args>

| Message                     | Action/Playbook                 | Blockchain | Network | Args                                                                                       |
|-----------------------------|---------------------------------|------------|---------|-------------------------------------------------------------------------------------------|--------------|
| upgrade test testnet v1.1.1 | Run the `upgrade.yml` playbook  | test       | testnet | `v1.1.1` (update `test_version` in `ansible/inventories/group_vars/<network>/test.yml`)  |
| packages test mainnet       | Run the `packages.yml` playbook | test       | mainnet | -                                                                                         |
| hostname test testnet       | Run the `hostname.yml` playbook | test       | testnet | -                                                                                         |

## Architecture

Test blockchain runs as a system-level Podman container managed by systemd via Quadlets.

**Networks:**

| Network | Validator  |
|---------|------------|
| testnet | testbed-ca |

**Inventory:** `ansible/inventories/group_vars/<network>/test.yml`

## Operations

### Status Check

```bash
# Check block height
curl -s http://<host>.tail46463.ts.net:8888/

# Service status (system-level)
ssh sol@<host>.tail46463.ts.net "sudo systemctl status sshd"

# Recent logs
ssh sol@<host>.tail46463.ts.net "sudo journalctl -u sshd -n 100"
```

### Configuration & Upgrades

Apply config changes or upgrade to a new version. Update `test_version` in inventory first if upgrading.

**All commands must use `work_dir: /tmp/chain-manager`** — this is the root of the chain-ops repository.

```bash
# Check service block height
just cmd test.yml <network> "curl http://localhost:8888"

# Check service status
just cmd test.yml <network> "sudo systemctl status ssh"

# Preview changes
just play test.yml packages.yml -u sol -CD

# Apply changes (single network)
just play test.yml packages.yml -l <network> -u sol

# Check service is running
just cmd test.yml <network> "sudo systemctl status ssh"

# Check that block height is increasing
just cmd test.yml <network> "curl http://localhost:8888"
```

## Playbooks

| Playbook | Purpose | User | Destructive |
|----------|---------|------|-------------|
| `upgrade.yml` | Upgrade blockchain | `sol` | No |
| `hostname.yml` | Print node hostname | `sol` | No |
| `packages.yml` | Upgrade packages | `sol` | No |

## Monitoring

Test blockchain exposes RPC on port 8888.

```bash
# Built-in RPC chain
curl -s http://<host>.tail46463.ts.net:8888/
```

## Safety Rules

1. **Use `-CD`** to preview changes before applying
2. **Restore ledger** prompts for confirmation (destructive)
3. **Upgrades are fast** - just pulls new container image
4. **Validator keys** are critical - stored at `/var/lib/snarkos/validator.key`
5. **Data directory** requires 0700 permissions for SnarkOS security checks
