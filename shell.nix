{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.docker
    pkgs.gnumake
    pkgs.php
  ];
}
