{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
     home-manager = {
       url = "github:nix-community/home-manager/release-23.11";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, ... }@inputs: 
  let
    inherit (self) outputs;
    pkgs = import nixpkgs;
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      # use this variant if unfree packages are needed:
      unstable = import nixpkgs-unstable {
	    inherit system;
      config.allowUnfree = true;
      };

  };
  in {
    
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
  
    nixosConfigurations = {

      default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          # import unstable packages
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })

          # system modules
          
          ./hosts/default/configuration.nix

          # home manager configuration
          home-manager.nixosModules.home-manager 
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gambit = import ./hosts/default/home.nix; 
            home-manager.extraSpecialArgs = { inherit overlay-unstable outputs; };
          }
        ];
      };
    };
  };
}
