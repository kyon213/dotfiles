function fish_user_key_bindings
    function _switch_to_default
        if commandline -P
            commandline -f cancel
        else
            set fish_bind_mode default
            commandline -f backward-char force-repaint
        end
    end

    # Map 'jj' and 'kk' to exit specific mode
    for mode in insert # visual replace
        bind -M $mode -m default jj _switch_to_default
        bind -M $mode -m default kk _switch_to_default
    end
end

