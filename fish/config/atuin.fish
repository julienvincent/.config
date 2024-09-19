set -g _atuin_history_offset -1
set -g _atuin_history_current_cmd ""

set -g _atuin_history_original_buffer ""
set -g _atuin_history_original_cursor_pos ""

function _atuin_history_search
    set h (RUST_LOG=error atuin search $_atuin_history_original_buffer \
            --limit 1 \
            --cmd-only \
            --offset $argv[1] \
            --search-mode prefix \
            --filter-mode session)

    if test $status -eq 0
        set -g _atuin_history_offset $argv[1]
        set -g _atuin_history_current_cmd $h
        commandline --replace $h
    end
end

function _atuin_history_reset_if_buffer_changed
    if test -1 != $_atuin_history_offset
        set -l current (commandline --current-buffer)
        if test "$current" != "$_atuin_history_current_cmd"
            set -g _atuin_history_offset -1
        end
    end
end

function _atuin_history_prev
    _atuin_history_reset_if_buffer_changed

    # Save original buffer and cursor on first up press
    if test -1 -eq $_atuin_history_offset
        set -g _atuin_history_original_buffer (commandline --current-buffer)
        set -g _atuin_history_original_cursor_pos (commandline --cursor)
    end

    _atuin_history_search (math $_atuin_history_offset + 1)
end

function _atuin_history_next
    _atuin_history_reset_if_buffer_changed

    switch $_atuin_history_offset
        case -1
            return
        case 0
            set -g _atuin_history_offset -1
            commandline --replace $_atuin_history_original_buffer
            commandline --cursor $_atuin_history_original_cursor_pos
        case '*'
            _atuin_history_search (math $_atuin_history_offset - 1)
    end
end

function _atuin_history_cancel --on-event fish_cancel
    set -g _atuin_history_offset -1
end

function _atuin_history_accept --on-event fish_preexec
    set -g _atuin_history_offset -1
end

function history-search-prev
    # Fallback to fish's builtin up-or-search if we're in search or paging mode
    if commandline --search-mode; or commandline --paging-mode
        up-or-search
        return
    end

    # Only invoke atuin if we're on the top line of the command
    set -l lineno (commandline --line)
    switch $lineno
        case 1
            _atuin_history_prev --shell-up-key-binding
        case '*'
            up-or-search
    end
end

function history-search-next
    # Fallback to fish's builtin down-or-search if we're in search or paging mode
    if commandline --search-mode; or commandline --paging-mode
        down-or-search
        return
    end

    # Only invoke atuin if we're on the bottom line of the command
    set -l lineno (commandline --line)
    set -l line_count (count (commandline))
    switch $lineno
        case $line_count
            _atuin_history_next --shell-up-key-binding
        case '*'
            down-or-search
    end
end

if status is-interactive
    atuin init fish --disable-up-arrow | source

    bind up history-search-prev
    bind -M insert up history-search-prev

    bind down history-search-next
    bind -M insert down history-search-next
end
