# Environment settings migrated from Zsh.
$env.EDITOR = 'nvim'
$env.GTK_APPLICATION_PREFER_DARK_THEME = '1'
$env.LANG = 'en_US.UTF-8'
$env.QT_QPA_PLATFORMTHEME = 'qt5ct'
$env.BROWSER = 'zen-browser'

# Nushell uses a list for PATH; avoid sourcing the POSIX-only .cargo/env script.
let cargo_bin = ($env.HOME | path join '.cargo' 'bin')
$env.PATH = ($env.PATH | prepend $cargo_bin | uniq)
