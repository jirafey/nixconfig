# flake.nix
{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "github:nix-community/home-manager/release-24.05";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = {
    hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
	home-manager.nixosModules.home-manager {
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.users.user = import ./home.nix;
	}
      ];
    };
  };
};
}
