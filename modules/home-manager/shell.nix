{
  # shell aliases
  programs.bash = {
    enable = true;
    shellAliases = {
      nu = "nix flake update ~/nixos/ && sudo nixos-rebuild switch --flake ~/nixos/#default";
      nr = "sudo nixos-rebuild switch --flake ~/nixos/#default";
      ng = "echo 'cleaning garbage & nix iterations older than 20days...' && sudo nix-collect-garbage --delete-older-than 20d";
      nd = "echo 'doing a dry-run...' && sudo nixos-rebuild dry-run --flake ~/nixos/#default";
      ls = "lsd";
      la = "lsd -a";
      yt-archive = "yt-dlp --embed-thumbnail --embed-subs --embed-metadata --embed-chapters --concurrent-fragments 3 --cookies-from-browser FIREFOX:3qxeajmi.default-release-1661478644995 --embed-chapters --sponsorblock-mark all --embed-info-json --sub-langs all,-live_chat --download-archive archive.txt --extractor-args 'youtube:lang=en'"; 
      };
    };
}
