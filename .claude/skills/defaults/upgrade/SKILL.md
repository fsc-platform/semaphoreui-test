---
pre_actions:
  - name: git_pull
    description: Ensure chain-ops repo is up to date before running upgrade
    command: git pull --ff-only
    work_dir: /tmp/chain-manager
  - name: just_init
    description: Ensure that we install any dependencies
    command: just init
    work_dir: /tmp/chain-manager
# post_actions:
#   - name: git_push
#     command: git push
#     work_dir: /tmp/chain-manager
# on_failure:
#   - name: cleanup
#     command: just cleanup
#     work_dir: /tmp/chain-manager
---
