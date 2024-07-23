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
      urls = [{ template = "https://www.startpage.com/rvd/search?query={searchTerms}&language=auto"; }];
      iconUpdateURL = "https://www.startpage.com/sp/cdn/favicons/mobile/android-icon-192x192.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
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
			urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
			iconUpdateURL = "https://wiki.nixos.org/nixos.png";
			updateInterval = 24 * 60 * 60 * 1000; # every day
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
      userContent = builtins.readFile ./userContent.css;
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
