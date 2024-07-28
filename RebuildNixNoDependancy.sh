#!/usr/bin/env bash
export NIX_CONFIG="experimental-features = nix-command flakes"
#nix shell nixpkgs#git --command nix flake clone github:ajundi/NixBuild --dest ~/nixos || true
echo "this script can be run on first build of a system right after a fresh install"

echo "It will Enabled flakes, Clone the flake from https://github.com/ajundi/NixBuild.git into ~/nixos and rebuild it"
echo "1- enabled flakes temporarily"
echo "copy /nixos/hardware-configuration.nix from /etc/nixos/ into "
echo "2- rename ~/nixos to ~/nixos_backup{timestamp}"
mv -v ~/nixos ~/nixos_backup_$(date +"%Y-%m-%d_%H-%M-%S")
echo "3- Clone the flake from https://github.com/ajundi/NixBuild.git into ~/nixos"
nix shell nixpkgs#git --command git clone --recursive https://github.com/ajundi/NixBuild.git ~/nixos
echo "4- go into ~/nixos"
cd ~/nixos
echo "Current Folder: '$(pwd)'."
nix shell nixpkgs#git --command git fetch --all
nix shell nixpkgs#git --command git branch backup-main
nix shell nixpkgs#git --command git reset --hard origin/main
echo "5- Copying current system's Configurations to flake directory"
cp -vrf /etc/nixos/hardware-configuration.nix ~/nixos/hardware-configuration.nix
echo "6- Update Lock file"
nix shell nixpkgs#git --command nix flake update
echo "7- Stage Commit Changes Locally"
nix shell nixpkgs#git --command git add -A
nix shell nixpkgs#git --command git config --global user.email ajundi@gmail.com
nix shell nixpkgs#git --command git config --global user.name Ayman Jundi #replace with but need to check that there is space in the name $(getent passwd $USER | cut -d ":" -f 5)
echo "8- Commit Changes Locally"
nix shell nixpkgs#git --command git commit -m "Commit of initial build on a new system $(date +"%Y-%m-%d_%H-%M-%S")"
echo "9- Rebuild system with flake"
nix shell nixpkgs#git --command sudo nixos-rebuild switch --flake ~/nixos/
#git clone --recursive https://github.com/ajundi/NixBuild.git ~/nixos
#sudo nixos-rebuild switch --flake github:ajundi/NixBuild
