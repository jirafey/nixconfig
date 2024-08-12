{ pkgs, ...}:

let
  startpage_query_base = "https://www.startpage.com/rvd/search";
  startpage_params = "?query={searchTerms}&language=auto";
  startpage_icon_url = "https://www.startpage.com/favicon.ico";
  day_in_milliseconds = 24 * 60 * 60 * 1000;

in

{

programs.firefox = {
   enable = true;
   package = pkgs.firefox-devedition;
   policies = {
     AppAutoUpdate = false;
     AutofillAddressEnabled = false;
     DefaultDownloadDirectory = "\${HOME}/Downloads";
     DisableAppUpdate = true;
     HardwareAcceleration = true;
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
      urls = [{ 
        template = "${startpage_query_base}${startpage_params}"; 
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
        #  PREF: Don't reveal your internal IP when WebRTC is enabled (Firefox >= 42)
        # https://wiki.mozilla.org/Media/WebRTC/Privacy
        # https://github.com/beefproject/beef/wiki/Module%3A-Get-Internal-IP-WebRTC
        media.peerconnection.ice.default_address_only = true;

        # PREF: Disable leaking network/browser connection information via Javascript
        # Network Information API provides general information about the system's connection type (WiFi, cellular, etc.)
        # https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API
        # https://wicg.github.io/netinfo/#privacy-considerations
        # https://bugzilla.mozilla.org/show_bug.cgi?id=960426
        "dom.netinfo.enabled" = false;
        # PREF: Disable raw TCP socket support (mozTCPSocket)
        # https://trac.torproject.org/projects/tor/ticket/18863
        # https://www.mozilla.org/en-US/security/advisories/mfsa2015-97/
        # https://developer.mozilla.org/docs/Mozilla/B2G_OS/API/TCPSocket
        "dom.mozTCPSocket.enabled" = false;

        #  PREF: Disable Web Audio API
        #  https://bugzilla.mozilla.org/show_bug.cgi?id=1288359
        #  NOTICE: Web Audio API is required for Unity web player/games
        "dom.webaudio.enabled" = false;

        "browser.translations.automaticallyPopup" = false;
        "signon.rememberSignons" = false;
	      "signon.autofillForms" = false;
        "browser.download.forbid_open_with" = true;
        "browser.download.start_downloads_in_tmp_dir" = true;
        "browser.download.open_pdf_attachments_inline" = true;
        "gfx.font_rendering.fontconfig.max_generic_substitutions" = 127;
        "browser.quitShortcut.disabled" = true;
        "ui.systemUsesDarkTheme" = 1;
        "widget.wayland.opaque-region.enabled" = false;
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "services.sync.prefs.sync-seen.services.sync.prefs.sync.capability.policy.maonoscript.sites" = true;
        "services.sync.prefs.sync.capability.policy.maonoscript.sites" = true;
        "noscript.sync.enabled" = true;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
	      "browser.safebrowsing.phishing.enabled" = false;
        "geo.enabled" = false;
	      "webgl.disabled" = true;
        "network.dns.echconfig.enabled" = true;
      	"network.dns.http3_echconfig.enabled" = true;
	      "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.enabled" = true;
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
