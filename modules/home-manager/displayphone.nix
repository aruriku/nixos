{ config, lib, pkgs, ... }:

{
  options.programs.displayphone = {
    enable = lib.mkEnableOption "enable displayphone";

    height = lib.mkOption {
      type = lib.types.int;
      default = 1080;
      description = "The height setting for displayphone.";
    };

    width = lib.mkOption {
      type = lib.types.int;
      default = 1920;
      description = "The width setting for displayphone.";
    };
  };

  config = lib.mkIf config.programs.displayphone.enable {
    home.packages = [ pkgs.displayphone ];

    home.file."${config.xdg.configHome}/displayphone/config".text = ''
      height=${toString config.programs.displayphone.height}
      width=${toString config.programs.displayphone.width}
    '';
  };
}
