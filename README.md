# Nix Configurations

Heavily influenced by https://github.com/mitchellh/nixos-config

## Build

```bash
export NIXPKGS_ALLOW_UNFREE=1
nix build --impure .#darwinConfigurations.macbook-air-m1.system
```

## Update flake

```bash
export NIXPKGS_ALLOW_UNFREE=1
nix flake update --impure .
```

## Switch

```bash
export NIXPKGS_ALLOW_UNFREE=1
darwin-rebuild switch --impure --flake .
```