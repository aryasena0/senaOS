#!/usr/bin/env bash
echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/lainix/hardware.nix

echo "-----"

echo "Setting Required Nix Settings Then Going To Install"
echo 'NIX_CONFIG="experimental-features = nix-command flakes"'
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"

echo "Updating Flake"
sudo nix flake update

echo "Rebuilding OS"
sudo nixos-rebuild switch --impure --flake ~/senaOS/#lainix --install-bootloader
