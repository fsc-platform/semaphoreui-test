# Justfile for chain-ops
# https://just.systems/

set dotenv-load := true
set shell := ["bash", "-uc"]
set positional-arguments := true

# Default recipe to display help
default:
    @just --list

# Initialize repo tooling
init:
    @echo "Installing Python dependencies..."
    uv sync --all-groups
    @echo "Installing Ansible Galaxy requirements..."
    uv run ansible-galaxy install -r ansible/requirements.yml --force

# Update all dependencies
update:
    @echo "Updating Python dependencies..."
    uv sync --upgrade
    @echo "Updating Ansible Galaxy requirements..."
    uv run ansible-galaxy install -r ansible/requirements.yml --force
    @echo "Dependencies updated successfully!"

# Run a shell command via Ansible
cmd inventory target *args:
    @echo "Running command via Ansible..."
    uv run ansible \
        -i ansible/inventories/{{inventory}} \
        -m ansible.builtin.command -a "{{args}}" \
        {{target}}

# Run a shell command via Ansible
shell inventory target *args:
    @echo "Running shell command via Ansible..."
    uv run ansible \
        -i ansible/inventories/{{inventory}} \
        -m ansible.builtin.shell -a "shell=/bin/bash cmd='{{args}}'" \
        {{target}}

# Run an ansible playbook
play inventory playbook *args:
    @echo "Running Ansible playbook..."
    uv run ansible-playbook \
        -i ansible/inventories/{{inventory}} \
        ansible/playbooks/{{playbook}} {{args}}
