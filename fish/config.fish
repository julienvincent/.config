for file in $XDG_CONFIG_HOME/fish/host/$(hostname)/config.pre.d/*.fish
    source $file
end

for file in $XDG_CONFIG_HOME/fish/config/*.fish
    source $file
end

for file in $XDG_CONFIG_HOME/fish/config.local/*.fish
    source $file
end

for file in $XDG_CONFIG_HOME/fish/host/$(hostname)/config.d/*.fish
    source $file
end

source $XDG_CONFIG_HOME/fish/modules/atuin.fish

set -gx EDITOR nvim

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

alias oc="opencode"

alias zshrc="nvim ~/.zshrc"
alias vimrc="nvim ~/.config/nvim"
alias vrest="nvim ~/.http"

if status is-interactive && type -q starship
    starship init fish | source
end

# opencode
fish_add_path /home/julienvincent/.opencode/bin
