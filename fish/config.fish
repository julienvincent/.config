for file in ~/.config/fish/config/*.fish
  source $file
end

set -gx EDITOR nvim

set -gx TAOENSSO_TIMBRE_CONFIG_EDN "{:min-level :error}"

set -g fish_autosuggestion_enabled 0
set fish_greeting ""

alias hr 'history --merge'  # read and merge history from disk

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

# mise activate fish | source
starship init fish | source
