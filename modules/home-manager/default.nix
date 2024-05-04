# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  bash = import ./shell.nix;
  mpv = import ./mpv.nix;
  dconf = import ./dconf.nix;
  firefox = import ./firefox.nix;
  easyeffects = import ./EasyEffects;
  fastfetch = import ./fastfetch;
  sops = import ./sops;
}
