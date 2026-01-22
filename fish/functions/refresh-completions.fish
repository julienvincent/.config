function refresh-completions
    for file in $XDG_CONFIG_HOME/fish/completions.d/*.fish
        source $file
    end

    for file in ~/.config/fish/host/$(hostname)/completions.d/*.fish
        source $file
    end
end
