{
  description = "redacted neex";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {nixpkgs = {follows = "nixpkgs";};};
    };
    wakatime-ls = {
      url = "github:mrnossiom/wakatime-ls";
      inputs = {nixpkgs = {follows = "nixpkgs";};};
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    wakatime-ls,
    ...
  }: {
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
              extraSpecialArgs = {inherit inputs;};
            };
          }
        ];
      };
    };
  };
}
