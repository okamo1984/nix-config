{
  description = "NixOS systems and tools";

  inputs = {
    # Pin our primary nixpkgs repository. This is the main nixpkgs repository
    # we'll use for our configurations. Be very careful changing this because
    # it'll impact your entire system.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";

      # We want to use the same set of nixpkgs as our system.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig.url = "github:mitchellh/zig-overlay";

    fenix = {
        url = "github:nix-community/fenix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, darwin, home-manager, nixpkgs, zig, fenix, nixpkgs-unstable }: let 
    overlays = [
        zig.overlays.default
        fenix.overlays.default
    ];
  in {
    packages.aarch64-darwin = fenix.packages.aarch64-darwin.default.toolchain;
    darwinConfigurations.macbook-air-m1 = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        { nixpkgs.overlays = overlays; }
        ./darwin.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.okamo = import ./home-manager.nix;
          home-manager.extraSpecialArgs = {
            inherit nixpkgs-unstable;
          };
        }
      ];
    };
  };
}
