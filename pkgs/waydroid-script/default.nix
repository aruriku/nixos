# taken from https://github.com/AtaraxiaSjel/nur/blob/master/pkgs/waydroid-script/default.nix
# I couldn't figure out how to overlay a NUR package :(

{ stdenv
, lib
, buildPythonApplication
, fetchFromGitHub
, substituteAll
, inquirerpy
, requests
, tqdm
, lzip
, util-linux
, nix-update-script
}:
let
  pname = "waydroid-script";
  version = "0-unstable-2024-01-20";
  src = fetchFromGitHub {
    repo = "waydroid_script";
    owner = "aruriku";
    rev = "09b919594760ce0f936a6db59c19d12016834649";
    hash = "sha256-eOm1pH7Wpok+PIdfXHSJDzSdYRpk3/Yl9A9R11aqYus=";
  };

  resetprop = stdenv.mkDerivation {
    pname = "resetprop";
    inherit version src;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share
      cp -r bin/* $out/share/
    '';
  };
in buildPythonApplication rec {
  inherit pname version src;

  propagatedBuildInputs = [
    inquirerpy
    requests
    tqdm

    lzip
    util-linux
  ];

  postPatch = let
    setup = substituteAll {
      src = ./setup.py;
      inherit pname;
      desc = meta.description;
      version = builtins.replaceStrings [ "-" ] [ "." ]
        (lib.strings.removePrefix "0-unstable-" version);
    };
  in ''
    ln -s ${setup} setup.py

    substituteInPlace stuff/general.py \
      --replace-fail "os.path.dirname(__file__), \"..\", \"bin\"," "\"${resetprop}/share\","
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "Python Script to add libraries to waydroid";
    homepage = "https://github.com/casualsnek/waydroid_script";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ataraxiasjel ];
  };
}