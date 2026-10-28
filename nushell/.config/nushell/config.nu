# Nushell-native vi editing replaces Zsh's bindkey -v.
$env.config = ($env.config | upsert show_banner false)
$env.config = ($env.config | upsert edit_mode 'vi')

# Native Nushell completions, syntax highlighting, and autosuggestions replace
# the Zsh-only plugins. Keep the familiar integrations and prompt.
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/atuin.nu
source ~/.config/nushell/starship.nu

# Familiar commands from .zshrc.
alias ls = ^lsd --icon=always
alias la = ^lsd -la --icon=always --group-dirs=first
alias ll = ^lsd -l --icon=always --group-dirs=first
alias tree = ^lsd --tree --depth=3 --icon=always --group-dirs=first
alias treea = ^lsd --tree --depth=3 --icon=always --group-dirs=first --all
alias v = ^nvim
alias sv = sudo -E nvim
alias ud = ^paru -Syu
alias rr = ^cargo run
alias re = ^cargo build
alias tmn = ^tmux new-session -s
alias tml = ^tmux ls
alias tmc = ^bash ~/.config/script/tmx.sh

# Fuzzy pick a file and open it in Neovim.
def f [] {
    let selected = (^fzf --preview 'bat --style=numbers --color=always --line-range=:500 {} || tree -C {}')
    if ($selected | is-not-empty) { ^nvim $selected }
}

# Fuzzy tmux session management.
def tmk [] {
    let selected = (^tmux ls | ^fzf --height 40% --reverse --prompt 'Select tmux session to kill: ')
    if ($selected | is-not-empty) {
        let session = ($selected | split row ':' | first | str trim)
        ^tmux kill-session -t $session
        print $'Killed tmux session: ($session)'
    } else {
        print 'No session selected'
    }
}

def tma [] {
    let selected = (^tmux ls | ^fzf --height 40% --reverse --prompt 'Select tmux session to attach: ')
    if ($selected | is-not-empty) {
        let session = ($selected | split row ':' | first | str trim)
        ^tmux attach-session -t $session
    } else {
        print 'No session selected'
    }
}

def tmd [] {
    if (($env.TMUX? | default '') | is-not-empty) {
        ^tmux detach
        print 'Detached from current tmux session.'
    } else {
        print 'Not inside a tmux session.'
    }
}
