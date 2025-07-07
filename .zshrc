# ------------------------------
# 🧠 Environment + General Setup
# ------------------------------

unsetopt PROMPT_SP PROMPT_CR     # Disable early Zsh fallback prompts
PROMPT=''                         # Disable default prompt
RPROMPT=''
PS1=""

export EDITOR=nvim
export GTK_THEME=Adwaita-dark
export GTK_APPLICATION_PREFER_DARK_THEME=1
export LANG=en_US.UTF-8
export PATH="$HOME/.cargo/bin:$PATH"
typeset -U PATH                  # Prevent $PATH duplicates

# Set Vim keybindings in shell (optional)
bindkey -e

# Disable Ctrl-S freeze
stty stop undef

# ------------------------------
# 🚀 Zsh Completion System
# ------------------------------

autoload -Uz compinit
compinit -u   # Use -u to avoid insecure directory warning

# Optional: Improve completion style
zstyle ':completion:*' completer _complete
zstyle ':completion:*' menu select
zstyle ':completion:*' fzf-search-display true

# ------------------------------
# 🔌 Plugin Setup (manual clones)
# ------------------------------

# Autosuggestions (Fish-style history suggestions)
if [[ ! -d ~/.zsh-plugins/zsh-autosuggestions ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh-plugins/zsh-autosuggestions
fi
source ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting (colorful command feedback)
if [[ ! -d ~/.zsh-plugins/zsh-syntax-highlighting ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh-plugins/zsh-syntax-highlighting
fi
source ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf-tab (fuzzy <Tab> completion)
if [[ ! -d ~/.zsh-plugins/fzf-tab ]]; then
  git clone https://github.com/Aloxaf/fzf-tab ~/.zsh-plugins/fzf-tab
fi
source ~/.zsh-plugins/fzf-tab/fzf-tab.plugin.zsh

bindkey '^J' autosuggest-accept

# ------------------------------
# ⚙️ Tools Setup
# ------------------------------

eval "$(zoxide init zsh)"       # Smarter cd
eval "$(atuin init zsh)"        # Better history + search
eval "$(starship init zsh)"     # Modern prompt

# Improve Ctrl+R UI for fzf
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:wrap"

# ------------------------------
# 📁 Aliases
# ------------------------------

alias ls='lsd --icon=always'
alias la='lsd -la --icon=always --group-dirs=first'
alias ll='lsd -l --icon=always --group-dirs=first'
alias tree='lsd --tree --depth=3 --icon=always --group-dirs=first'
alias v='nvim'
alias sv='sudo -E nvim'
alias ud='paru -Syuu'
alias rr='cargo run'
alias re='cargo build'

# ------------------------------
# 🔧 Utility Functions
# ------------------------------

# Fuzzy select a file to open in nvim
f() {
  fzf --preview 'bat --style=numbers --color=always --line-range=:500 {} || tree -C {}' \
      --bind 'enter:execute(nvim {})'
}

# Tmux session management
alias tmn="tmux new-session -s"
alias tml="tmux ls"
alias tmc="/home/vishal/.config/script/tmx.sh"

tmk() {
  session=$(tmux ls | fzf --height 40% --reverse --prompt "Select tmux session to kill: ")
  if [[ -n $session ]]; then
    session_name=$(echo $session | awk '{print $1}')
    tmux kill-session -t "$session_name"
    echo "Killed tmux session: $session_name"
  else
    echo "No session selected"
  fi
}

tma() {
  session=$(tmux ls | fzf --height 40% --reverse --prompt "Select tmux session to attach: ")
  if [[ -n $session ]]; then
    session_name=$(echo $session | awk '{print $1}')
    tmux attach -t "$session_name"
    echo "Attached to tmux session: $session_name"
  else
    echo "No session selected"
  fi
}

tmd() {
  if [[ -n "$TMUX" ]]; then
    tmux detach
    echo "Detached from current tmux session."
  else
    echo "Not inside a tmux session."
  fi
}
