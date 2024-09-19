eval "$(/opt/homebrew/bin/brew shellenv)"

fish_add_path $HOME/.local/google-cloud-sdk/bin
fish_add_path --move $HOME/.local/bin

fish_add_path --move "/opt/homebrew/opt/make/libexec/gnubin"

set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
