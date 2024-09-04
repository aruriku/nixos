# configures a consistent default profile with some preferred defaults configured
{ configs, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        path = "default";
        search = {
          engines = {
            # add nix packages as a search engine
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "4get" = {
              urls = [{ template = "https://4get.ca/web?s={searchTerms}"; }];
              iconUpdateURL = "https://4get.ca/favicon.ico";
              updateInterval = 7 * 24 * 60 * 60 * 1000; #update once a week
              definedAliases = [ "@4g" ];
            };
            # disable bing
            "Bing".metaData.hidden = true;
          };
          #force search config changes (replaces configuration)
          force = true;
          # set 4get to the default
          default = "4get";
          # prioritise google and nix packages in search
          order = [ "4get" "Google" "Nix Packages"];
        };
        settings = {
          # Enable hardware decoding support
          "media.ffmpeg.vaapi.enabled" = true;
          # Disable pocket
          "extensions.pocket.enabled" = false;
          # Enable xdg desktop portal
          # TODO: check that system is linux before enabling
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };
      };
    };
  };
}