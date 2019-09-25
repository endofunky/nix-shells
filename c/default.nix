{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

(overrideCC stdenv gcc9).mkDerivation {
  name = "hello";

  buildInputs = with pkgs; [
    bear
    ccls
  ];

  shellHook = ''
    [[ -f ./.env ]] && . ./.env
  '';
}
