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
  
    homeManagerModules = import ./modules/home-manager;
  
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs;};
      modules = [
	({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
	./modules/nixos/gnome.nix
        ./hosts/default/configuration.nix
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
}
