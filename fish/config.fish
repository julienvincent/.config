for file in ~/.config/fish/config/*.fish
    source $file
end

for file in ~/.config/fish/config.local/*.fish
    source $file
end

set -gx EDITOR nvim

# set -gx TAOENSSO_TIMBRE_CONFIG_EDN "{:min-level :error}"

set -g fish_autosuggestion_enabled 0
set fish_greeting ""

# read and merge history from disk
alias hr 'history --merge'

alias p="pnpm"
alias pl="pnpm link --global"
alias px="pnpx"

alias ka="kafkactl"

alias ls="lsd"

alias vim="nvim"

alias zshrc="nvim ~/.zshrc"
alias vimrc="nvim ~/.config/nvim"
alias vrest="nvim ~/.http"

if status is-interactive
    starship init fish | source
end
