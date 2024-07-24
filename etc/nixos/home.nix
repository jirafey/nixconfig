# home.nix
{ lib, pkgs, ... }:
let
  startpage_query_base = "https://www.startpage.com/rvd/search";
  startpage_params = "?query={searchTerms}&language=auto";
  startpage_icon_url = "https://www.startpage.com/favicon.ico";
  day_in_milliseconds = 24 * 60 * 60 * 1000;

  
in
{
  home.username = "user";
  home.homeDirectory = "/home/user";
  # You do not need to change this if you're reading this in the future.
  # Don't ever change this after the first build.  Don't ask questions.
  home.stateVersion = "24.05";

  programs.firefox = {
   enable = true;
   package = pkgs.firefox-devedition;
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
    profiles.dev-edition-default = {

    search = {
      force = true;
      default = "Startpage";
      order = [
      "Startpage"
      "NixOS Wiki"
      "Nix Packages"
      "Tabs"
      "Bookmarks"
      "History"
      ];

      engines = {
      "Startpage" = {
      urls = [{ template = "${startpage_query_base}";
      params = [
        { name = "query"; value = "{searchTerms}"; }
	{ name = "language"; value = "auto"; }
      ];
      }];
      iconUpdateURL = "${startpage_icon_url}"; 
      updateInterval = day_in_milliseconds;
      definedAliases = [ "@s" ];
      };
      "Nix Packages" = {
        urls = [{
          template = "https://search.nixos.org/packages";
	  params = [
	  { name = "type"; value = "packages"; }
	  { name = "query"; value = "{searchTerms}"; }
	  ];
          }];

icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
definedAliases = [ "@np" ];
};
"NixOS Wiki" = {
urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; 
}];
iconUpdateURL = "https://wiki.nixos.org/nixos.png";
updateInterval = day_in_milliseconds;
definedAliases = [ "@nw" ];
      };

      "Google".metaData.hidden = true;
      "eBay".metaData.hidden = true;
      "Wikipedia (en)".metaData.hidden = true;
      "Bing".metaData.hidden = true;
      "DuckDuckGo".metaData.hidden = true;
      };

    };

      userChrome = builtins.readFile ./userChrome.css;
      settings = {
        "devtools.chrome.enabled" = true;
        "devtools.debugger.remote-enabled" = true;
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
