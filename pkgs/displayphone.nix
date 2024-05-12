
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
    version = "3746f25";
    src = fetchFromGitHub {
      # https://github.com/aruriku/displayphone
      owner = "aruriku";
      repo = "displayphone";
      rev = "3746f2580ce24681daff50f837ce2c9a104c85da";
      sha256 = "sha256-SBuELU+zH3+OtyjlgTLQfDHeO+xQGuhCDJYzXch+yBA=";
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
