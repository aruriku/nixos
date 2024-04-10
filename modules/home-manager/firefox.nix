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
        # prioritise google, open tabs, and nix packages
        search.order = [ "Google" "Tabs" "Nix Packages"];
      };
    };
  };
}