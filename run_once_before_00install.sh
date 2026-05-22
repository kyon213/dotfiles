#!/bin/bash
# ==============================================================================
# Chezmoi Bootstrap Script: Run ONCE Before Dotfiles Deployment
# Target: Auto-detect OS, update Apt/Homebrew, and install core software.
# ==============================================================================

set -euo pipefail # Strict mode: Fail instantly if any command exits with a non-zero status

echo "🚀 [Bootstrap] Awakening the ultimate Chezmoi provisioning engine..."

# ------------------------------------------------------------------------------
# 1. OS Defensive Layer: For Linux environments, initialize base dependencies via Apt
# ------------------------------------------------------------------------------
if [[ "$(uname)" == "Linux" ]]; then
  echo "📦 [Apt] Linux environment detected. Synchronizing system package repositories..."
  sudo apt-get update

  # Install essential low-level tools required to build Homebrew and run base CLIs
  sudo apt-get install -y build-essential locales unzip curl cmake ninja-build ccache python3 python3-pip
fi

# ------------------------------------------------------------------------------
# 2. Core Framework Layer: Verify and automatically install Homebrew if missing
# ------------------------------------------------------------------------------
if ! command -v brew &>/dev/null; then
  echo "🍺 [Homebrew] Homebrew not found. Launching non-interactive automated installation..."
  # This automatically triggers the official Homebrew installer shell script
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Environment anti-jitter: A freshly installed brew isn't on the current PATH yet.
  # We must force-inject the brew binary path into the current script shell execution context.
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
  elif [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv bash)"
  fi
else
  echo "🍺 [Homebrew] Homebrew is already present. Skipping base installation."
fi

# ------------------------------------------------------------------------------
# 3. Complete Loop Layer: Leverage Homebrew Bundle to recall all software stacks
# ------------------------------------------------------------------------------
echo "🎯 [Homebrew Bundle] Resolving and installing core software via repository Brewfile..."

# Dynamically query the active chezmoi source path to find your tracked Brewfile.
brew bundle --file="${CHEZMOI_SOURCE_DIR}/dot_Brewfile"

echo "✨ [Bootstrap] Infrastructure successfully provisioned! Handing over to Chezmoi to deploy dotfiles..."
