{
  nixpkgs ? import <nixpkgs> {
    overlays = [
      (self: super: {
        jdk = super.jdk11;
      })
    ];
  }
}:

with nixpkgs;

mkShell {
  buildInputs = with pkgs; [
    jdk
    leiningen
  ];

  shellHook = ''
    [[ -f ./.env ]] && . ./.env
  '';
}
