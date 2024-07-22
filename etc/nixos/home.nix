# home.nix
{ config, pkgs, ... }:
  {
      
    home.username = "user";
    home.homeDirectory = "/home/user";
    # You do not need to change this if you're reading this in the future.
    # Don't ever change this after the first build.  Don't ask questions.
    home.stateVersion = "24.05";

    programs.home-manager.enable = true;
    
   programs.firefox = {
  enable = true;
  profiles = {
    dev-edition-default = {
      userChrome = ''
        /* some css */
      '';
    };
  };
};
  }
