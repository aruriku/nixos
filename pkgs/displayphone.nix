
{ stdenv
, lib
, fetchFromGitHub
, bash
, android-tools
, makeWrapper
, scrcpy
}:
  stdenv.mkDerivation {
    pname = "displayphone";
    version = "e9ecd20";
    src = fetchFromGitHub {
      # https://github.com/loliteToT/displayphone
      owner = "loliteToT";
      repo = "displayphone";
      rev = "e9ecd200e5edc7b290b0c7e5be5e789063cd4361";
      sha256 = "sha256-9U62z6ow0dbE6obMJ/kZSXDZT/tS3JCPjuGSwTd9kao=";
    };
    buildInputs = [ bash scrcpy android-tools ];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      cp displayphone.sh $out/bin/displayphone.sh
      chmod +x $out/bin/displayphone.sh
      wrapProgram $out/bin/displayphone.sh \
        --prefix PATH : ${lib.makeBinPath [ bash scrcpy android-tools ]}
    '';
  }
