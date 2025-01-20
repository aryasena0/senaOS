#!/usr/bin/env bash
echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/lainix/hardware.nix

echo "-----"

echo "Setting Required Nix Settings Then Going To Install"
NIX_CONFIG="experimental-features = nix-command flakes"

echo "-----"

sudo nixos-rebuild switch --flake ~/zaneyos/#lainix
