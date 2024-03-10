function repl
  clojure -Sdeps "$(cat deps.local.edn)" -M:nrepl:service:local:dev:test
end
