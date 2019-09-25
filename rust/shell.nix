{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  nixpkgs = import <nixpkgs> {
    overlays = [
      (import (builtins.fetchTarball
        https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz))
    ];
  };
  rust = (nixpkgs.latest.rustChannels.stable.rust.override {
    extensions = [
      "rls-preview"
      "rust-analysis"
      "rust-src"
      "rustfmt-preview"
    ];
  });
in
with nixpkgs; mkShell {
  name = "hello";

  buildInputs = [
    rust
    rustup
  ];

  shellHook = ''
    [[ -f ./.env ]] && . ./.env

    export CARGO_HOME="$PWD/.cargo"
    export RUSTUP_HOME="$PWD/.rustup"
  '';
}
