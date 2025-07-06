{
  description = "redacted neex";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    zed-extensions = {
      url = "github:DuskSystems/nix-zed-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wakatime-ls = {
      url = "github:mrnossiom/wakatime-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      zed-extensions,
      home-manager,
      ...
    }:
    {
      nixosConfigurations = {
        nix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.syk = import ./home.nix;
                extraSpecialArgs = {
                  inherit inputs;
                };
              };

              nixpkgs.overlays = [
                zed-extensions.overlays.default
              ];

              home-manager.sharedModules = [
                zed-extensions.homeManagerModules.default
              ];
            }
          ];
        };
      };
    };
}
