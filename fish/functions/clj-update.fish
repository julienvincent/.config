function clj-update
  set focus
  
  if test (count $argv) -gt 0
    set focus :focus "\"$argv\""
  end

  clojure -Tantq outdated \
    :upgrade true \
    :force true \
    :skip \"github-action\" \
    :skip \"babashka\" \
    $focus
end
