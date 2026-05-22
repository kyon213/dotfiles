#!/usr/bin/env fish
# ==============================================================================
# Chezmoi Lifecycle Script: Run ONCE After Dotfiles Deployment
# Target: Persist one-time interactive Fish settings (Themes, Universal Paths).
# ==============================================================================

echo "🐠 [Fish Config] Beginning one-time active environment injection..."

if status is-interactive
    echo "🎨 [Theme] Applying Catppuccin-Mocha theme color palette..."
    fish_config theme choose catppuccin-mocha
end

echo "🚀 [Path] Persisting ~/.local/bin into global fish environment..."
fish_add_path --path $HOME/.local/bin

echo "✨ [Fish Config] One-time environment configuration successfully baked!"
