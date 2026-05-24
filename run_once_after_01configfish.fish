#!/usr/bin/env fish
# ==============================================================================
# Chezmoi Lifecycle Script: Run ONCE After Dotfiles Deployment
# Target: System Default Login Shell Provisioning
# ==============================================================================

echo "🛡️ [System] Verifying system default shell configurations..."

set -l fish_path (which fish)

if test "$SHELL" = "$fish_path"
    echo "✅ [Shell] Fish is already established as your default system login shell."
else
    read -l -P "❓ [Prompt] Do you want to set Fish as your default system shell? (y/N): " user_choice
    switch (string lower "$user_choice")
        case y yes
            echo "🔄 [Shell] Proceeding with system default shell changes..."
            # Ensure the current Fish binary path is white-listed inside /etc/shells
            if not grep -q "^$fish_path\$" /etc/shells
                echo "🔑 [Privilege] Registering $fish_path into /etc/shells (Sudo password may be required)..."
                echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
            else
                echo "✅ [System] $fish_path is already approved in /etc/shells."
            end
            # Change the user's default login shell
            echo "🔄 [Shell] Changing your system default shell to $fish_path..."
            sudo chsh -s "$fish_path"
        case '*'
            echo "⏭️  [Shell] Change skipped by user. Keeping your current default shell."
    end
end
