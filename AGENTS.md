# NixOS + nix-darwin Configuration for rstlss

## Repository Structure

```
/nixcfg/
├── flake.nix
├── opencode.json
├── hosts/
│ ├── rstlss-lab-pc/          # NixOS system (x86_64-linux)
│ │ ├── default.nix          # Hostname, users, timezone, system modules
│ │ ├── hardware.nix         # Hardware configuration
│ │ └── disko.nix            # Disk setup with disko
│ └── rstlss-macbook/        # macOS system (aarch64-darwin)
│ └── default.nix          # Hostname, users, system configuration
├── modules/
│ ├── nixos/                # Reusable system toggles
│ │ ├── hyprland.nix         # Hyprland system configuration
│ │ └── snapshots.nix        # System snapshots configuration
│ └── home/                 # Reusable home-manager pieces
│ ├── appearance.nix         # Desktop appearance settings
│ ├── direnv.nix            # direnv setup
│ ├── directories.nix       # Directory structure
│ ├── fzf.nix               # fzf configuration
│ ├── fd.nix                # fd file search configuration
│ ├── foot.nix              # Foot terminal emulator
│ ├── git.nix               # Git configuration
│ ├── hyprland.nix          # Hyprland window manager
│ ├── neovim/              # Neovim configuration
│ │ ├── default.nix         # Neovim setup with plugins
│ │ └── lua/               # Neovim Lua configuration
│ │ ├── autocmds.lua       # Auto-commands
│ │ ├── colorscheme.lua    # Colorscheme
│ │ ├── cmp.lua            # Completion
│ │ ├── conform.lua        # Code formatting
│ │ ├── gitsigns.lua       # Git signs
│ │ ├── keymaps.lua        # Key mappings
│ │ ├── lint.lua           # Linting
│ │ ├── lazydev.lua        # Lazydev
│ │ ├── lsp.lua            # Language Server Protocol
│ │ ├── mini.lua           # Mini UI library
│ │ ├── navic.lua          # LSP breadcrumbs
│ │ └── options.lua        # Neovim options
│ │ └── telescope.lua      # Telescope fuzzy finder
│ ├── packages.nix          # User packages
│ ├── ssh.nix              # SSH client configuration
│ ├── starship.nix          # Starship prompt
│ ├── tmux.nix             # Tmux configuration
│ ├── v2rayn.nix            # V2RayN client
│ ├── xsession.nix         # X session configuration
│ └── zsh.nix              # Zsh shell configuration
├── home/
│ └── rstlss/             # Home-manager configuration for rstlss user
│ └── default.nix         # Imports all home modules
└── .git/                 # Git metadata
```

## Key Configuration Files

### flake.nix

Main flake file that defines the NixOS and macOS configurations with inputs for nixpkgs, disko, home-manager, and nix-darwin.

### hosts/default.nix (per system)

Each host system includes:

- System-specific imports (hardware, disko, etc.)
- User configuration
- System settings (hostname, timezone, etc.)

### modules/home/neovim/

Comprehensive Neovim setup with:

- Colorscheme (gruvbox-nvim)
- Treesitter parsers for multiple languages
- Completion (nvim-cmp with luasnip)
- LSP configuration
- Code formatting and linting (conform + nvim-lint)
- Telescope fuzzy finder
- Git integration (gitsigns)

### home/rstlss/default.nix

Home-manager configuration that imports all user modules:

- Shell configuration (zsh)
- Terminal configuration (foot, tmux)
- Neovim
- Git tools
- Package management tools (ripgrep, etc.)
- Window manager (Hyprland on Linux)

## Build and Usage

```bash
# Build the system configuration
nix build .#nixosConfigurations.rstlss-lab-pc

# Build the macOS configuration
nix build .#darwinConfigurations.rstlss-macbook

# Deploy to NixOS
sudo nixos-rebuild switch --flake .

# Deploy to macOS
sudo nix-darwin switch --flake .
```

## System Information

- **NixOS Configuration**: rstlss-lab-pc (x86_64-linux)
- **macOS Configuration**: rstlss-macbook (aarch64-darwin)
- **User**: rstlss
- **Shell**: zsh
- **Window Manager**: Hyprland (Linux) / macOS native
- **Editor**: Neovim with extensive plugin support
