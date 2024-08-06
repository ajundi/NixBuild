#!/usr/bin/env bash
export NIX_CONFIG="experimental-features = nix-command flakes"
#nix shell nixpkgs#git --command nix flake clone github:ajundi/NixBuild --dest ~/nixos || true
echo "this script can be run on first build of a system right after a fresh install"
echo "It will Enabled flakes, Clone the flake from https://github.com/ajundi/NixBuild.git into ~/nixos and rebuild it"
#TODO make this list available options when applied to multiple computers Also configuration file should follow this host name. (make it a selectable list) List should parse the flake show command output.
profile="nixos"
echo "Enter the host name default is:${profile} when left empty."
read profile
if [$profile -e ""]
then
    profile="nixos"
fi
echo "Selected host:${profile}"
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
echo "7- Stage all Changes Locally. Building a flake requires files to be at least tracked in git or staged."
nix shell nixpkgs#git --command git add -A
set -e # from here on out exit on error to prevent committing (also if git name and email are not defined it will fail committing)
echo "8- Rebuild system with flake"
nix shell nixpkgs#git --command sudo nixos-rebuild switch --flake $HOME/nixos#"$profile"
echo "9- Commit Changes Locally"
nix shell nixpkgs#git --command git commit -m "Commit of initial build on a new system $(date +"%Y-%m-%d_%H-%M-%S")"

