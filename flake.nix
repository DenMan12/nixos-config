{
  description = "NixOS configuration for spdmrf's laptop (Niri + Noctalia + ArtCraft)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    millennium = {
      url = "github:SteamClientHomebrew/Millennium";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, millennium }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./configuration.nix

        # Home Manager as NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.spdmrf = import ./home.nix;
        }

        # Millennium overlay
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ millennium.overlays.default ];
        })
      ];

      specialArgs = {
        inherit millennium;
      };
    };
  };
}
