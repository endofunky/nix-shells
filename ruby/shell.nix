{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  ruby = stdenv.mkDerivation rec {
    name = "ruby-2.6.4";

    buildInputs = with pkgs; [
      gdbm groff libffi libyaml ncurses openssl readline zlib
    ] ++ stdenv.lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Foundation darwin.libobjc libiconv libunwind
    ];

    enableParallelBuilding = true;

    configureFlags = ["--enable-shared" "--enable-pthread"];

    src = fetchurl {
      url = "https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.4.tar.gz";
      sha256 = "0dvrw4g2igvjclxk9bmb9pf6mzxwm22zqvqa0abkfnshfnxdihag";
    };
  };
in
mkShell {
  buildInputs = with pkgs; [
    ruby
  ];

  shellHook = ''
    [[ -f ./.env ]] && . ./.env

    mkdir -p .nix-gems

    export GEM_HOME=$PWD/.nix-gems/$(ruby -e "puts RUBY_VERSION")
    export GEM_PATH=$GEM_HOME
    export PATH=$GEM_HOME/bin:$PATH
  '';
}
