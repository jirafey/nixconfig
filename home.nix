# home.nix
{ config, lib, pkgs, inputs, ... }:

{

  imports = [
    # inputs.nixvim.homeManagerModules.nixvim
    ];
  nixpkgs.overlays = [ <kickstart-nix-nvim>.overlays.default ];

  home.username = "user";
  home.homeDirectory = "/home/user";
  # You do not need to change this if you're reading this in the future.
  # Don't ever change this after the first build.  Don't ask questions.
  home.stateVersion = "24.05";
  home.packages = [
    #inputs.nvim-flake.packages.${pkgs.stdenv.system}.default
    inputs.kickstart-nix.packages.${pkgs.stdenv.system}.default
  ];
}
