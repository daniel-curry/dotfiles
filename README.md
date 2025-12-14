# Dotfiles

Personal configuration files for my Linux development environment with Hyprland compositor.

## Quick Start

Clone this repository to your home directory:
```bash
git clone https://github.com/daniel-curry/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

**Warning:** The setup script will replace existing configurations. Back up your current configs before running.

## Included Configurations

### Window Manager & Compositor
- **[Hyprland](hypr/)** - Modern Wayland compositor
  - `hyprland.conf` - Main configuration
  - `hypridle.conf` - Idle daemon settings
  - `hyprlock.conf` - Screen locker configuration
  - `hyprpaper.conf` - Wallpaper daemon
  - `local_config.conf` - Machine-specific overrides

### Status Bar & Launcher
- **[Waybar](waybar/)** - Highly customizable status bar for Wayland
  - Custom scripts for media player, workspace management
  - `hypr_listener.sh` - Hyprland event listener
- **[Ulauncher](ulauncher/)** - Application launcher with extensions support

### Terminal & Shell
- **[Kitty](kitty/)** - GPU-accelerated terminal emulator
- **[Zsh](zsh/)** - Shell configuration with plugins
  - `.zshrc` - Main shell configuration
  - `.zsh_plugins.txt` - Plugin management
- **[Tmux](tmux/)** - Terminal multiplexer configuration

### Development
- **[Neovim](nvim/)** - Modern Vim-based text editor
  - Lazy.nvim plugin manager setup
  - Custom Lua configuration

### System Utilities
- **[btop](btop/)** - Resource monitor with themes
- **[cava](cava/)** - Console-based audio visualizer
  - Custom shaders and themes
- **[keyd](keyd/)** - Key remapping daemon (requires root)

### Visual Assets
- **[Wallpapers](Wallpapers/)** - Collection of desktop backgrounds

## Installation Details

The `setup.sh` script performs the following:

1. **Creates symlinks** from `~/.config/<app>` to `~/dotfiles/<app>`
2. **Special handling** for:
   - **Zsh**: Links `.zshrc` and `.zsh_plugins.txt` to home directory
   - **Tmux**: Links `.tmux.conf` to home directory
   - **Keyd**: Links config to `/etc/keyd/` (requires sudo)
3. **Skips**: Wallpapers directory (not a config)

## Prerequisites

### Required Packages
```bash
# Arch Linux / Arch-based distros
sudo pacman -S hyprland waybar kitty zsh tmux neovim btop cava keyd

# Optional but recommended
sudo pacman -S ulauncher hypridle hyprlock hyprpaper
```

### Additional Setup

**Zsh plugins**: Install [antidote plugin manager](https://github.com/mattmc3/antidote) or your preferred plugin manager.

**Keyd**: Enable and start the service:
```bash
sudo systemctl enable --now keyd
```

## Customization

- **Hyprland**: Edit `hypr/local_config.conf` for machine-specific settings without affecting version control
- **Waybar**: Modify scripts in `waybar/` for custom modules
- **Color schemes**: Check individual app theme directories

## File Structure

```
dotfiles/
├── btop/           # System monitor themes
├── cava/           # Audio visualizer config
├── hypr/           # Hyprland compositor
├── keyd/           # Keyboard remapping
├── kitty/          # Terminal emulator
├── nvim/           # Text editor
├── tmux/           # Terminal multiplexer
├── ulauncher/      # Application launcher
├── waybar/         # Status bar
├── zsh/            # Shell configuration
├── Wallpapers/     # Desktop backgrounds
├── setup.sh        # Installation script
└── README.md       # This file
```

## Contributing

Feel free to fork and customize for your own use. Pull requests welcome for bug fixes.

## License

MIT License - Feel free to use and modify as needed.
