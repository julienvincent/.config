if status is-interactive
    kubectl completion fish | source
end

function kubecolor --wraps kubectl
    command kubecolor $argv
end

function k --wraps kubectl
    command kubecolor $argv
end
