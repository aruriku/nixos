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
        search.engines = {
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
          # disable bing
          "Bing".metaData.hidden = true;
        };
        #force search config changes (replaces configuration)
        search.force = true;
        # prioritise google and nix packages in search
        search.order = [ "Google" "Nix Packages"];

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