#!/usr/bin/env fish
# ==============================================================================
# Chezmoi Lifecycle Script: Run ONCE After Dotfiles Deployment
# Target: Persist one-time Fish settings (Themes, Paths, Default shell, etc).
# ==============================================================================

echo "🐠 [Fish Config] Beginning one-time active environment injection..."

# ------------------------------------------------------------------------------
# 1. Visual Environment Layer (Interactive UI Only)
# ------------------------------------------------------------------------------
if status is-interactive
    echo "🎨 [Theme] Applying Catppuccin-Mocha theme color palette..."
    fish_config theme choose catppuccin-mocha
end

# ------------------------------------------------------------------------------
# 2. System Environment Path Layer
# ------------------------------------------------------------------------------
echo "🚀 [Path] Persisting ~/.local/bin into global fish environment..."
fish_add_path --path $HOME/.local/bin

# ------------------------------------------------------------------------------
# 3. System Default Shell Layer (Defensive Guardrails)
# ------------------------------------------------------------------------------
echo "🛡️ [System] Verifying system default shell configurations..."

# Step A: Resolve the absolute physical path of the active Fish binary
set -l fish_path (which fish)

# Step B: Check if Fish is already the default shell to avoid redundant prompts
if test "$SHELL" = "$fish_path"
    echo "✅ [Shell] Fish is already established as your default system login shell."
else
    # Step C: Prompt the user for an interactive choice
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

echo "✨ [Fish Config] One-time environment configuration successfully baked!"
