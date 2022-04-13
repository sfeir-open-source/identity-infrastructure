{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.php
    pkgs.php.packages.composer
  ];
}
