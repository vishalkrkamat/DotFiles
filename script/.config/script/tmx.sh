#!/bin/bash

# Exit on error, unset vars, and pipe failure
set -euo pipefail

# Ensure working directory is absolute (resolves symlinks)
WORKDIR=$(readlink -f "$PWD")

# Get the current directory name (not full path)
SESSION_NAME=$(basename "$WORKDIR")

# Check if tmux is installed
if ! command -v tmux &>/dev/null; then
    echo "Error: tmux is not installed." >&2
    exit 1
fi

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "A tmux session named '$SESSION_NAME' already exists." >&2
    exit 2
fi

# Create a new tmux session detached with window 'main'
tmux new-session -d -s "$SESSION_NAME" -n main -c "$WORKDIR"

# Create two additional windows with correct working directories
tmux new-window -t "$SESSION_NAME" -n dev -c "$WORKDIR"
tmux new-window -t "$SESSION_NAME" -n logs -c "$WORKDIR"

# Switch to the main window before attaching
tmux select-window -t "$SESSION_NAME:main"

# Attach to the session
tmux attach -t "$SESSION_NAME"
