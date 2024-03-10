function clj-update
  clojure -Sdeps '{:deps {com.github.liquidz/antq {:mvn/version "2.9.1221"}}}' \
    -M -m antq.core \
    --skip=github-action \
    --skip=babashka \
    --upgrade \
    $argv
end
