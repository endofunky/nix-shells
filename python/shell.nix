{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  python = (python36.withPackages(ps: with ps; [
    pip
    python-language-server
    pyls-isort
    pyls-black
  ]));
in
mkShell {
  buildInputs = with pkgs; [
    python
  ];

  shellHook = ''
    [[ -f ./.env ]] && . ./.env

    export PYTHON_VERSION="$(python -V | awk '{ print $2 }' | ( IFS=".$IFS" ; read a b c && echo $a.$b ))"
    export PIP_PREFIX="$PWD/.pip/$PYTHON_VERSION"
    export PYTHONPATH="${python}/lib/python$PYTHON_VERSION/site-packages:$PYTHONPATH"
    export PYTHONPATH="$PIP_PREFIX/lib/python$PYTHON_VERSION/site-packages:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin/:$PATH"
  '';
}
