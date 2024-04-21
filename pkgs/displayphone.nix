
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
    version = "0ab93cd";
    src = fetchFromGitHub {
      # https://github.com/loliteToT/displayphone
      owner = "loliteToT";
      repo = "displayphone";
      rev = "0ab93cdf7f9b4dd2f339562ca94dcf304ae78592";
      sha256 = "sha256-dkKw7mAuY9Htwmji6dfvdIe1wE33KFGykHoNHy7kNTY=";
    };
    buildInputs = [ bash scrcpy android-tools ];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      #Install script
      mkdir -p $out/bin
      cp displayphone.sh $out/bin/displayphone
      chmod +x $out/bin/displayphone
      wrapProgram $out/bin/displayphone \
        --prefix PATH : ${lib.makeBinPath [ bash scrcpy android-tools ]}

      mkdir -p $out/share/applications
      cp displayphone.desktop $out/share/applications
      chmod +x $out/share/applications/displayphone.desktop
    '';
}
