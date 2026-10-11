# ------------------------------
# 🧠 Environment + General Setup
# ------------------------------

unsetopt PROMPT_SP PROMPT_CR     # Disable early Zsh fallback prompts
PROMPT=''                         # Disable default prompt
RPROMPT=''
PS1=""

export EDITOR=nvim
export GTK_APPLICATION_PREFER_DARK_THEME=1
export LANG=en_US.UTF-8
export PATH="$HOME/.cargo/bin:$PATH"
typeset -U PATH                  # Prevent $PATH duplicates

# Set Vim keybindings in shell (optional)
bindkey -v

# backspace in all zle keymaps (vi insert + normal + emacs)
bindkey -a '^?' backward-delete-char   # vicmd
bindkey -M viins '^?' backward-delete-char

# Disable Ctrl-S freeze
stty stop undef

# ------------------------------
# 🚀 Zsh Completion System
# ------------------------------

autoload -Uz compinit
compinit

# fzf-tab configuration
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept'
zstyle ':fzf-tab:*' preview 'bat --color=always --style=numbers {}'

# ------------------------------
# 🔌 Plugin Setup
# ------------------------------

# Autosuggestions (Fish-style history suggestions)
[[ -r ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf-tab (fuzzy <Tab> completion)
[[ -r ~/.zsh-plugins/fzf-tab/fzf-tab.plugin.zsh ]] && \
  source ~/.zsh-plugins/fzf-tab/fzf-tab.plugin.zsh

# Syntax Highlighting (colorful command feedback)
[[ -r ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey '^F' autosuggest-accept

# ------------------------------
# ⚙️ Tools Setup
# ------------------------------

eval "$(zoxide init zsh)"       # Smarter cd

export ATUIN_NOBIND=true
eval "$(atuin init zsh)"       #Better history + search
bindkey '^S' atuin-search

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
alias treea='lsd --tree --depth=3 --icon=always --group-dirs=first --all'
alias v='nvim'
alias sv='sudo -E nvim'
alias ud='paru -Syu'
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
alias tmc="$HOME/.config/script/tmx.sh"

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
setopt ignore_eof
