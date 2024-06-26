
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
    version = "65a621d";
    src = fetchFromGitHub {
      # https://github.com/aruriku/displayphone
      owner = "aruriku";
      repo = "displayphone";
      rev = "65a621d0925ebd114238518b2412ce0b098fd207";
      sha256 = "sha256-/Go6k1eMX1gCeOkCvsqhe+ns12HKn/9vUkgjD1yo898=";
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
