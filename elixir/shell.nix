{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  elixirDrv = { mkDerivation }: mkDerivation {
    version = "1.9.1";
    sha256 = "106s2a3dykc5iwfrd5icqd737yfzaz1dw4x5v1j5z2fvf46h96dx";
    minimumOTPVersion = "20";
  };
  erlangDrv = { mkDerivation }: mkDerivation {
    version = "21.0";
    sha256 = "0khprgawmbdpn9b8jw2kksmvs6b45mibpjralsc0ggxym1397vm8";
  };
  erlang = beam.lib.callErlang erlangDrv {
    wxGTK = wxGTK30;
  };
  rebar = pkgs.rebar.override {
    inherit erlang;
  };
  elixir = beam.lib.callElixir elixirDrv {
    inherit erlang rebar;
    debugInfo = true;
  };
  elixir-ls = stdenv.mkDerivation rec {
    name = "elixir-ls";
    version = "0.2.25";

    src = fetchurl {
      url = "https://github.com/JakeBecker/elixir-ls/releases/download/v${version}/elixir-ls.zip";
      sha256 = "0q1dnlh07rzx34inxf7n40crh000xrvq2zyp3936nfi0plqv28db";
    };

    phases = "installPhase fixupPhase";

    buildInputs = [ elixir unzip makeWrapper ];

    installPhase = ''
      mkdir -p $out/share/elixir-ls
      mkdir -p $out/bin
      ${pkgs.unzip}/bin/unzip $src -d $out/share/elixir-ls
      chmod +x $out/share/elixir-ls/*.sh
      makeWrapper $out/share/elixir-ls/language_server.sh $out/bin/language_server.sh --set PATH "${elixir}/bin/:$PATH"
      makeWrapper $out/share/elixir-ls/debugger.sh $out/bin/debugger.sh --set PATH "${elixir}/bin/:$PATH"
    '';
  };
in
mkShell {
  buildInputs = with pkgs; [
    elixir
    elixir-ls
  ];

  shellHook = ''
    [[ -f ./.env ]] && . ./.env

    export ERL_LIBS=""
    export MIX_ARCHIVES="$PWD/.mix/archives"
  '';
}
