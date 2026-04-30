#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting dotfiles installation (Niri Setup) ===${NC}\n"

DOTFILES_DIR="$HOME/dotfiles"

# ---------------------------------------------------------
# STAGE 1: Symlinking configurations
# ---------------------------------------------------------
echo -e "${YELLOW}[1/3] Creating symbolic links...${NC}"

# Ensure .config directory exists
mkdir -p "$HOME/.config"

# List of config directories
configs=("alacritty" "niri" "fastfetch" "nvim" "cava" "waybar")

for config in "${configs[@]}"; do
    echo "Linking $config..."
    # Remove existing config to avoid conflicts
    rm -rf "$HOME/.config/$config"
    # Create the symbolic link
    ln -sf "$DOTFILES_DIR/config/$config" "$HOME/.config/$config"
done

# Link Zsh profile
echo "Linking .zshrc..."
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

echo -e "${GREEN}Configurations successfully linked!${NC}\n"

# ---------------------------------------------------------
# STAGE 2: Installing packages and fonts
# ---------------------------------------------------------
echo -e "${YELLOW}[2/3] Installing required packages and fonts...${NC}"

# Check for yay (AUR helper)
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}yay not found! Please install yay before running this script.${NC}"
    exit 1
fi

# Package list
PACKAGES=(
    "niri"
    "waybar"
    "alacritty"
    "neovim"
    "zsh"
    "fastfetch"
    "cava"
    "sddm"
    "fzf"
    "mpv"
    "ttf-jetbrains-mono-nerd"
)

# Install using yay
yay -S --needed "${PACKAGES[@]}"

echo -e "${GREEN}Packages installed!${NC}\n"

# ---------------------------------------------------------
# STAGE 3: System configuration (SDDM & Zsh)
# ---------------------------------------------------------
echo -e "${YELLOW}[3/3] Finalizing system setup...${NC}"

# Configure SDDM
echo "Copying SDDM settings..."
if [ -d "$DOTFILES_DIR/sddm" ]; then
    sudo cp -r "$DOTFILES_DIR/sddm/"* /etc/sddm.conf.d/ 2>/dev/null || sudo cp "$DOTFILES_DIR/sddm/sddm.conf" /etc/sddm.conf
    sudo systemctl enable sddm.service
fi

# Change default shell to Zsh
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "Changing default shell to Zsh..."
    chsh -s /usr/bin/zsh
fi

echo -e "\n${GREEN}=== Installation Complete! ===${NC}"
echo "It is recommended to reboot your system or restart Niri."
