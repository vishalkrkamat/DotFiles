# Path configuration
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export GTK_THEME=Adwaita-dark
export GTK_APPLICATION_PREFER_DARK_THEME=1
# User configuration
# Set preferred language
export LANG=en_US.UTF-8

# Uncomment the following line to set your preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Uncomment to set compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Uncomment to export MANPATH if needed
# export MANPATH="/usr/local/man:$MANPATH"

# Uncomment to change your auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment to change how often to auto-update (in days)
# zstyle ':omz:update' frequency 13

# Uncomment to disable magic functions
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment to disable LS colors
# DISABLE_LS_COLORS="true"

# Uncomment to disable auto-setting terminal title
# DISABLE_AUTO_TITLE="true"

# Uncomment to enable command auto-correction
# ENABLE_CORRECTION="true"

# Uncomment to display red dots for completion waiting
# COMPLETION_WAITING_DOTS="true"

# Uncomment to disable marking untracked files under VCS as dirty
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment to change history timestamp format
# HIST_STAMPS="mm/dd/yyyy"

# Uncomment to use a custom folder for Oh My Zsh
# ZSH_CUSTOM=/path/to/new-custom-folder

# Set theme
ZSH_THEME="bira"

# Set list of themes to pick from when loading at random (Optional)
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Enable case-sensitive completion (Optional)
# CASE_SENSITIVE="true"

# Enable hyphen-insensitive completion (Optional)
# HYPHEN_INSENSITIVE="true"

# Which plugins to load
# Example format: plugins=(git rails textmate)
plugins=(git)

# Initialize Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Initialization for plugins
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

# Aliases
alias ll='ls -la'
alias v='nvim'
alias sv='sudo -E nvim'
alias ud='paru -Syuu'
alias rr='cargo run'
alias re='cargo build'

# FZF-based function for file selection
f() {
  fzf --preview 'bat --style=numbers --color=always --line-range=:500 {} || tree -C {}' --bind 'enter:execute(nvim {})'
}

# Tmux session management
# Create a new tmux session
alias tmn="tmux new-session -s"

# List all tmux sessions
alias tml="tmux ls"

# Function to kill tmux session
tmk() {
  session=$(tmux ls | fzf --height 40% --reverse --prompt "Select tmux session to kill: ")

  if [[ -n $session ]]; then
    session_name=$(echo $session | awk '{print $1}')
    tmux kill-session -t $session_name
    echo "Killed tmux session: $session_name"
  else
    echo "No session selected"
  fi
}

# Function to attach to a tmux session
tma() {
  session=$(tmux ls | fzf --height 40% --reverse --prompt "Select tmux session to attach: ")

  if [[ -n $session ]]; then
    session_name=$(echo $session | awk '{print $1}')
    tmux attach -t $session_name
    echo "Attached to tmux session: $session_name"
  else
    echo "No session selected"
  fi
}

# Function to detach from the current tmux session
tmd() {
  if [ -n "$TMUX" ]; then
    tmux detach
    echo "Detached from the current tmux session."
  else
    echo "Not inside a tmux session. No action taken."
  fi
}

. "/home/vishal/.deno/env"
