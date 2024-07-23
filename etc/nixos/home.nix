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
   policies = {
     AppAutoUpdate = false;
     AutofillAddressEnabled = false;
     DefaultDownloadDirectory = "\${HOME}/Downloads";
     DisableAppUpdate = true;
     DisablePocket = true;
     DisableTelemetry = true;
     DontCheckDefaultBrowser = true;
     Homepage.StartPage = "previous-session";
     NoDefaultBookmarks = true;
   };
    profiles.default = {
    search = {
        default = "Startpage";
	 engines = {

      "Google".metaData.alias = "@g";
      "Google".icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
"Nix Packages" = {
    urls = [{
      template = "https://search.nixos.org/packages";
      params = [
        { name = "type"; value = "packages"; }
        { name = "query"; value = "{searchTerms}"; }
      ];
    }];

    icon = ""; 
    definedAliases = [ "@np" ];
  };
      };
      };

      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
      settings = {
	"extensions.pocket.enabled" = false;
	"browser.toolbars.bookmarks.visibility" = "never";
	"browser.urlbar.oneOffSearches" = false;
	"datareporting.healthreport.service.enabled" = false;
        "font.name.monospace.x-western" = "JetBrainsMono Nerd Font Mono";
        "reader.parse-on-load.enabled" = false;
        "svg.context-properties.content.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
	"browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        };
      };
    };
}
