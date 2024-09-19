function clj-update
    set -l options (fish_opt --short=f --long=focus)
    set options $options (fish_opt --short=F --long=force)

    argparse $options -- $argv
    or return

    if set -q _flag_force
        echo "Clearing resolver statuses"
        find ~/.m2/ -name "resolver-status.properties" -delete
    end

    set -l focus
    if set -q _flag_focus
        set focus :focus "[\"$_flag_focus\"]"
    end

    clojure -Tantq outdated \
        :upgrade true \
        :force true \
        :skip "[\"github-action\", \"babashka\"]" \
        $focus
end
