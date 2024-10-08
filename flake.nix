# flake.nix
{
  
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixvim = {
    #  url = "github:nix-community/nixvim?ref=nixos-24.05";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
    #nvim-flake = {
     #url = "github:jirafey/nvim-flake";
    #inputs.nixpkgs.follows = "nixpkgs";
    #};
    kickstart-nix = {
      url = "github:jirafey/kickstart-nix.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs @ { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
   	      home-manager.nixosModules.home-manager {
	      home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.user = {
	        imports = [
                  ./home.nix
	          ./modules/firefox/firefox.nix
	          ./modules/nvim.nix
	          ./modules/bash.nix
            #./modules/dev/c.nix
            # ./modules/keyd/keyd.nix
	        ];
	      };
	    }
        ];
      };
    };
  };
}
