---
pre_actions:
  - name: git_pull
    description: Ensure chain-ops repo is up to date before running upgrade
    command: git pull --ff-only
    work_dir: /tmp/chain-manager
  - name: git_branch
    command: 'git checkout -b "chore/upgrade_<blockchain>_<network>_<version>" main'
    work_dir: /tmp/chain-manager
  - name: just_init
    description: Ensure that we install any dependencies
    command: just init
    work_dir: /tmp/chain-manager
post_actions:
  - name: git_add
    command: git add -A
    work_dir: /tmp/chain-manager
  - name: git_commit
    command: 'git diff --cached --quiet || git commit -m "chore(<blockchain>): upgrade
  <blockchain> <network> to <version>"'
    work_dir: /tmp/chain-manager
  - name: git_push
    command: git push -u origin HEAD
    work_dir: /tmp/chain-manager
  - name: gh_create_pr
    command: gh pr create --fill
    work_dir: /tmp/chain-manager
# on_failure:
#   - name: cleanup
#     command: just cleanup
#     work_dir: /tmp/chain-manager
---
