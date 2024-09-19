function dbuild
    docker build \
        --build-arg GITHUB_TOKEN=$(gh auth token) \
        --build-arg GITHUB_USERNAME=$(gh api user | jq -r .login) \
        $argv
end
