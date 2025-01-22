#!/usr/bin/env bash

# ==========================================================
# Script to clone or update senaOS repository, configure
# hardware settings, and rebuild NixOS with the appropriate flake.
# ==========================================================

REPO_URL="https://github.com/aryasena0/senaOS.git"
TARGET_DIR="$HOME/senaOS"

# Function to clone or update the repository
update_repository() {
    if [ -d "$TARGET_DIR" ]; then
        echo "[INFO] Repository found at '$TARGET_DIR'. Pulling the latest changes..."
        cd "$TARGET_DIR" && git pull --rebase
    else
        echo "[INFO] Repository not found. Cloning '$REPO_URL'..."
        git clone "$REPO_URL" "$TARGET_DIR" || { echo "[ERROR] Git clone failed! Exiting."; exit 1; }
    fi
}

# Function to generate hardware configuration
generate_hardware_config() {
    echo "[INFO] Generating hardware configuration..."
    sudo nixos-generate-config --show-hardware-config > "$TARGET_DIR/hosts/lainix/hardware.nix" || { echo "[ERROR] Failed to generate hardware configuration! Exiting."; exit 1; }
}

# Function to update NixOS flake
update_flake() {
    echo "[INFO] Updating NixOS flake..."
    sudo nix flake update || { echo "[ERROR] Flake update failed! Exiting."; exit 1; }
}

# Function to rebuild the NixOS system
rebuild_system() {
    echo "[INFO] Rebuilding NixOS system..."
    sudo nixos-rebuild switch \
        --install-bootloader \
        --impure \
        --upgrade \
        --flake "$TARGET_DIR/#lainix" || { echo "[ERROR] NixOS rebuild failed! Exiting."; exit 1; }
}

# ==========================================================
# Main Execution Flow
# ==========================================================

# Update or clone the repository
update_repository

# Generate the hardware configuration
generate_hardware_config

# Set Nix configuration for experimental features
export NIX_CONFIG="experimental-features = nix-command flakes"
echo "[INFO] Set NIX_CONFIG to enable experimental features."

# Update the NixOS flake
update_flake

# Rebuild the NixOS system with the updated configuration
rebuild_system

echo "[INFO] NixOS rebuild completed successfully!"

