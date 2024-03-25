{ configs, pkgs, ...}:
let 
  shaders_dir = "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders";
in {
  home.packages = with pkgs;  [
    mpv-shim-default-shaders
  ];
  programs.mpv = {
    enable = true;
    bindings = {
      "h" = "cycle deband";
      "s"  = "screenshot";
      "b"  = "cycle interpolation";
      "ALT+j"  = "add sub-scale +0.1";
      "WHEEL_UP"  = "add volume 2"; # default “seek 10”
      "WHEEL_DOWN" = "add volume -2"; # default “seek -10”
    };
    config = {
      # general stuff
      autofit = "70%";

      # video
      profile = "gpu-hq";
      gpu-api = "vulkan";
      vo = "gpu-next";
      hwdec = "auto";

      # audio
      ao = "pipewire";
      alang = "eng,en,jpn,jp";
      slang = "enm,eng,en,enCA,enUS,jpn,jp";
      sub-auto = "fuzzy";
      subs-with-matching-audio = "yes"; # can be removed after 0.36.0'

      # shaders
      glsl-shader = "~~/shaders/FSRCNNX_x2_8-0-4-1.glsl";
      scale = "lanczos";
      cscale = "lanczos";
      dscale = "mitchell";
      deband = "yes";
      scale-antiring = "1"; 

      # network streaming
      demuxer-max-back-bytes = "50Mib";
      demuxer-max-bytes = "600Mib";
      demuxer-readahead-secs = "300";
      force-seekable = "yes"; # for seeking when not preloaded

      #screenshotting
      screenshot-format = "png";
      screenshot-directory = "~/Pictures/mpv screenies";
      screenshot-template = "%f-%wH.%wM.%wS.%wT-#%#00n"; # name-hour-minute-second-millisecond-ssnumb
    };
    scripts = with pkgs; [ 
      mpvScripts.autocrop
	    mpvScripts.thumbfast
	    mpvScripts.sponsorblock
	    mpvScripts.inhibit-gnome
    ];
  };
  home.file = {
    ".config/mpv/shaders/FSRCNNX_x2_8-0-4-1.glsl".source = "${shaders_dir}/FSRCNNX_x2_8-0-4-1.glsl";
  };
}