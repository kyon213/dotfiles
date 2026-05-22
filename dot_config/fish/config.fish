# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Global Configurations (Environment variables, PATH, etc.)
# These apply to all sessions, including scripts and non-interactive tasks.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Setup PATH, MANPATH, INFOPATH, and other variables
if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

set -gx LANG en_US.UTF-8
set -gx EDITOR nvim

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Interactive Configurations
# This block runs only when you are using the terminal manually.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if status is-interactive

    set -g fish_greeting
    set -g fish_key_bindings fish_vi_key_bindings

    alias v='nvim'
    alias l='ls -lhtra'

    # alias proxy='eval $(mihoro proxy export); echo "Proxy On"'
    # 由于 mihoro proxy export 未做分行的 bug，需要暂时修改为
    alias proxy='mihoro proxy export | string replace -a "set -gx" "; set -gx" | source; echo "Proxy On"'
    alias unproxy='eval $(mihoro proxy unset); echo "Proxy Off"'
end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Utilities
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function fix_code --description 'Update VS Code IPC socket from tmux'
    # set -l latest_socket (ls -tr /run/user/(id -u)/vscode-ipc-* 2>/dev/null | tail -n 1)
    set -l latest_socket (lsof -u (whoami) 2>/dev/null | grep -o '/run/user/0/vscode-ipc-.*\.sock' | head -n 1)

    if test -n "$latest_socket"
        set -gx VSCODE_IPC_HOOK_CLI "$latest_socket"
        echo "VS Code IPC socket updated to: $VSCODE_IPC_HOOK_CLI"
    else
        echo "No active VS Code IPC socket found."
    end
end
