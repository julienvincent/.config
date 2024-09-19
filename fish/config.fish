for file in ~/.config/fish/config/*.fish
  source $file
end

set -gx EDITOR nvim

set -gx TAOENSSO_TIMBRE_CONFIG_EDN "{:min-level :error}"

set -g fish_autosuggestion_enabled 0
set fish_greeting ""

# read and merge history from disk
alias hr 'history --merge'

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

starship init fish | source

# The default backwards search uses fuzzy matching instead of exact prefix matching
bind -M insert \e\[A history-prefix-search-backward
bind -M insert \e\[B history-prefix-search-forward
