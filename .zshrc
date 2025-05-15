# Disable any early fallback prompt from Zsh
unsetopt PROMPT_SP
unsetopt PROMPT_CR
PROMPT=''
RPROMPT=''

# # Remove extra newlines if they're still printed
PS1=""
export PS1
#
export EDITOR=nvim

#Set vim key binding
bindkey -v

# Set preferred GTK theme (Optional)
export GTK_THEME=Adwaita-dark
export GTK_APPLICATION_PREFER_DARK_THEME=1

# Set preferred language (Optional)
export LANG=en_US.UTF-8

# Aliases (Optional: Keep useful ones)
alias ll='ls -la'
alias v='nvim'
alias sv='sudo -E nvim'
alias ud='paru -Syuu'
alias rr='cargo run'
alias re='cargo build'

# FZF-based function for file selection (Optional: Keep if useful)
f() {
  fzf --preview 'bat --style=numbers --color=always --line-range=:500 {} || tree -C {}' --bind 'enter:execute(nvim {})'
}

# Tmux session management (Optional: Keep if useful)
alias tmn="tmux new-session -s"
alias tml="tmux ls"
alias tmc="/home/vishal/.config/script/tmx.sh"

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

# Path for Cargo binaries (add this if you haven't already)
export PATH="$HOME/.cargo/bin:$PATH"

# Initialize plugins (zoxide and atuin can be kept)
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

eval "$(starship init zsh)"
