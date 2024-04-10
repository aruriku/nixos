{
  # shell aliases
  programs.bash = {
    enable = true;
    shellAliases = {
      nu = "nix flake update $HOME/nixos/ && sudo nixos-rebuild switch --flake \"$HOME/nixos/#$(hostname)\"";
      nr = "sudo nixos-rebuild switch --flake \"$HOME/nixos/#$(hostname)\"";
      ng = "echo 'cleaning garbage & nix iterations older than 20days...' && sudo nix-collect-garbage --delete-older-than 20d";
      nd = "echo 'doing a dry-run...' && sudo nixos-rebuild dry-run --flake \"$HOME/nixos/#$(hostname)\"";
      ls = "lsd";
      la = "lsd -a";
      yt-archive = "yt-dlp --embed-thumbnail --embed-subs --embed-metadata --embed-chapters --concurrent-fragments 3 --cookies-from-browser FIREFOX:3qxeajmi.default-release-1661478644995 --embed-chapters --sponsorblock-mark all --embed-info-json --sub-langs all,-live_chat --download-archive archive.txt --extractor-args 'youtube:lang=en'"; 
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
}
