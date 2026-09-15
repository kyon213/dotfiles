# Personal Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Philosophy

Software management is layered: the distro owns the system bedrock, everything
user-installable goes through a versioned no-sudo manager, and special-purpose
layers handle what user-space tools cannot.

<!-- markdownlint-disable MD013 -->

| Layer | Scope & Core Scenarios | Typical Examples | Governance Philosophy |
| --- | --- | --- | --- |
| **Distro (APT, RPM, dnf, ...)** | OS core, low-level dependencies, drivers, dev headers, base commands | `curl`, `git`, `build-essential` | **Strictly Conservative**: system bedrock only; never replaced by user-level tools |
| **mise** | All user-space tooling: CLI productivity, language runtimes, build tools, LSPs — prebuilt-first, source-build fallback | `fish`, `tmux`, `neovim`, `ripgrep`, `fzf`, `fd`, `cmake`, `ninja`, `ccache`, `clangd`, `node` | **Versioned Rolling**: no-sudo user installs, per-project pinning; in shared-deployment mode all tools live at `<dotfiles_base>/.local/share/mise`, reused read-only across machines |
| **~/.local/bin** | One-off or custom-built artifacts not in any registry | `wezterm` (static), self-compiled tools | **Minimal**: only hand-placed binaries; everything registry-able goes to mise (shared mode: `<dotfiles_base>/.local/bin`) |
| **Docker** | Legacy or system-bound environments and long-running services that user-space isolation cannot reproduce | legacy CUDA stacks, daemonized services | **Fully Enclosed Sandbox**: ephemeral execution, zero host contamination |
| **GUI / Desktop** | Desktop applications, outside mise's CLI scope | browsers, VS Code | **Distro packages first; Flatpak / AppImage / portable tarballs when no sudo** |

<!-- markdownlint-enable MD013 -->

Principles:

- **Shadow, not replace**: when a system tool is outdated and sudo is
  unavailable, install a newer version via mise and let `PATH` precedence
  shadow the system one; never uninstall system packages.
- **mise's boundary**: mise does not cover the system layer, security-critical
  tools (`ssh`, `sudo`), GUI applications, long-running services, or source
  builds that need system dev headers (when sudo is unavailable, prefer
  prebuilt/musl binaries).
- **Isolation hierarchy**: per-project tool versions → `mise.toml`;
  per-project Python environments → mise-managed Python + `uv`/venv; only
  environments that cannot be reproduced in user space go to Docker.

## Features

### Shared-deployment mode (`dotfiles_base`)

By default everything installs per-machine (mise in `~/.local/share/mise`,
chezmoi source in the standard `~/.local/share/chezmoi`). When `chezmoi init`
is given a non-empty **deployment base** (a path on a disk shared by several
machines at the same mount point), this repo additionally:

- sets `sourceDir` to `<dotfiles_base>/.local/share/chezmoi`, mirroring the
  standard home layout on the shared disk;
- derives `MISE_DATA_DIR` (`<dotfiles_base>/.local/share/mise`) and
  `MISE_CONFIG_DIR` (`<dotfiles_base>/.config/mise`) from the same base, so
  tools are installed once and reused read-only by every machine mounting
  that disk;
- replaces `apt`/`brew` provisioning (no sudo) with `mise install` on machines
  that have network access.

This mode fits environments where an offline LAN mirrors an online one on the
same shared disk: configure once on the online side, consume read-only on the
offline side.

### `internet_access` switch

`chezmoi init` asks whether the machine has internet access. When `no`, the
generated shell configs disable mise's auto-install
(`MISE_AUTO_INSTALL` / `MISE_NOT_FOUND_AUTO_INSTALL`), preventing any network
attempt; machines with access simply keep mise's defaults (auto-install on).

### Other configurable switches

- `is_heavy_workstation`: install LLVM/LLD etc. on capable machines.
- `enable_blog_debug`: install `hugo`/`gh` for local blog debugging.

## Usage

### Prerequisites

Install mise, then use mise to install chezmoi:

```shell
# 1. Install mise (default per-machine path ~/.local/bin/mise)
curl -fsSL https://mise.run | sh
mise --version
```
Shared-deployment mode installs mise into the base instead:
`MISE_INSTALL_PATH` is an environment variable read by the installer script,
so it must be set on the `sh` command (not on curl):
```shell
curl -fsSL https://mise.run | MISE_INSTALL_PATH=<dotfiles_base>/.local/bin/mise sh
mise --version

# 2. Install and globally register chezmoi via mise
#    (mise install alone does not add an unconfigured tool to PATH;
#    `use -g` also writes it to the global config, which activation puts
#    on PATH. In shared-deployment mode this writes to the shared
#    MISE_CONFIG_DIR exported below.)
export MISE_DATA_DIR=<dotfiles_base>/.local/share/mise
export MISE_CONFIG_DIR=<dotfiles_base>/.config/mise
mise use -g chezmoi@latest
```

### First-Time Setup

```shell
chezmoi init --apply git@github.com:kyon213/dotfiles.git
```

`chezmoi init` asks a few questions (identity, optional switches, and
shared-deployment settings). The `dotfiles_base` question is the switch that
enables shared deployment: press Enter for the default per-machine install, or
type a path on a shared disk (e.g. an existing `dotfiles` directory there) to
route tools, mise data and the chezmoi source onto that disk as described in
[Features](#features).

## My Workflow Packages

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
  - [lspconfig](https://github.com/neovim/nvim-lspconfig) with mise-managed
`clangd` and basic setup.
- ~~[Reasonix](https://github.com/esengine/deepseek-reasonix) Promising but
problematic (light mode terminal, configuration file location, etc.)~~
