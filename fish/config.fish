for file in ~/.config/fish/config/*.fish
  source $file
end

set -gx EDITOR nvim

set -g fish_autosuggestion_enabled 0
set fish_greeting ""

alias p="pnpm"
alias pl="pnpm link --global"
alias px="pnpx"

alias k="kubectl"
alias ka="kafkactl"

alias ls="lsd"

alias vim="nvim"

alias zshrc="nvim ~/.zshrc"
alias vimrc="nvim ~/.config/nvim"
alias vrest="nvim ~/.http"

mise activate fish | source
starship init fish | source
