# home.nix
{ lib, pkgs, ... }:
{
  home.username = "user";
  home.homeDirectory = "/home/user";
  # You do not need to change this if you're reading this in the future.
  # Don't ever change this after the first build.  Don't ask questions.
  home.stateVersion = "24.05";

  programs.firefox = {
    enable = true;
    profiles.default = {
      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
	"extensions.pocket.enabled" = false;
	"browser.toolbars.bookmarks.visibility" = "never";
        };
      };
    };
}
