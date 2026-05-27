# Personal Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Usage

### First-Time Setup

```shell
chezmoi init --apply git@github.com:kyon213/dotfiles.git`
```

## Features

### My Packages Management Philosophy
<!-- markdownlint-disable MD013 -->

| Layer/Tool | Scope & Core Scenarios | Typical Examples | Governace Philosophy |
| --- | --- | --- | --- |
| **APT** | OS core, low-level dependencies, system drivers, and base toolchains | `curl`, `git`, `build-essential` | **Strictly Conservative**: Only install cirtical system bedrock |
| **Homebrew** | Host-generic, standalone CLI productivity tools. | `ripgrep`, `fzf`, `fd`, `hugo` | **Rolling Release**: Up-to-date tools free of complex runtime chains. |
| **Docker** | Complex research projects, legacy environments, and long-running background services. | `PyTorch 1.12` | **Fully Enclosed Sandbox**: Ephermeral execution to ensure zero host contamination. |
| `~/.local/bin`(**XDG**) | Cross-language, standalone, high-frequency updated interactive applications. | `aider`, `uv`, `mihoro` | **User-Managed Sandbox**, Maintained via dedicated isolation engines (e.g., `uv tools`) or self-contained binaries. |

<!-- markdownlint-enable MD013 -->
### My Workflow Packages

- [git](https://github.com/git/git) configured with personal info and
[git alias](https://github.com/GitAlias/gitalias).
- [fish-shell](https://github.com/fish-shell/fish-shell) customised with
vim-style keybindings and theme.
- [tmux](https://github.com/tmux/tmux) customised with vim-style keybindings
and plugins ([tpm](https://github.com/tmux-plugins/tpm),
[resurrect](https://github.com/tmux-plugins/tmux-resurrect),
[continuum](https://github.com/tmux-plugins/tmux-continuum),
[catppuccin](https://github.com/catppuccin/tmux)).
- [neovim](https://github.com/neovim/neovim) bundled with
[LazyVim](https://github.com/LazyVim/LazyVim) and personal modifications.
  - Optional enabled [LazyExtras](https://www.lazyvim.org/extras) based on
chezmoi switches: [clangd](https://www.lazyvim.org/extras/lang/clangd),
[markdown](https://www.lazyvim.org/extras/lang/markdown).
  - 80 column highlighted.
  - [blink.cmp](https://github.com/saghen/blink.cmp) customised key mapping.
  - [catppuccin-latte](https://github.com/catppuccin/nvim) with transparent
background.
  - [lspconfig](https://github.com/neovim/nvim-lspconfig) with local
brew-installed clangd and basic setup.
- [Aider](https://github.com/Aider-AI/aider) with
[deepseek](https://www.deepseek.com/) customisations.
