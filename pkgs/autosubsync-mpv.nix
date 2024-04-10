{ lib, stdenv, fetchFromGitHub, makeWrapper, ffsubsync, ffmpeg }:

stdenv.mkDerivation rec {
  pname = "autosubsync-mpv";
  version = "22cb928ecd94cc8cadaf8c354438123c43e0c70d";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "autosubsync-mpv ";
    rev = "22cb928ecd94cc8cadaf8c354438123c43e0c70d";
    sha256 = "0mxfykdq8685ipdxd3w6bgnbzyr5a2s50pwibd03ccbxp45wa0sx";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ffmpeg ffsubsync ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts/autosubsync
    cp -r ./* $out/share/mpv/scripts/autosubsync

    wrapProgram $out/share/mpv/scripts/autosubsync/autosubsync.lua --prefix PATH : ${lib.makeBinPath [ ffmpeg ffsubsync ]}
    runHook postInstall
  '';

  meta = {
    description = "Automatic subtitle synchronization script for mpv.";
    homepage = "https://github.com/joaquintorres/autosubsync-mpv";
    license = stdenv.lib.licenses.mit;
  };
}