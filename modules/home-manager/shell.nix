{
  # shell aliases
  programs.bash = {
    enable = true;
    shellAliases = {
      nu = "nix flake update ~/nixos/ && sudo nixos-rebuild switch --flake ~/nixos/";
      nr = "sudo nixos-rebuild switch --flake ~/nixos/";
      ng = "echo 'cleaning garbage & nix iterations older than 20days...' && sudo nix-collect-garbage --delete-older-than 20d";
      nd = "echo 'doing a dry-run...' && sudo nixos-rebuild dry-run --flake ~/nixos/";
      ls = "lsd";
      la = "lsd -a";
      yt-archive = "yt-dlp --embed-thumbnail --embed-subs --embed-metadata --embed-chapters --concurrent-fragments 3 --cookies-from-browser FIREFOX:default --embed-chapters --sponsorblock-mark all --embed-info-json --sub-langs all,-live_chat --download-archive archive.txt --extractor-args 'youtube:lang=en'"; 
      };
  };
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "aru" = {
        hostname = "192.168.2.183";
        user = "seb";
      };
    };
  };
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "vim";
  };
}
