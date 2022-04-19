{
  description = "Application architecture reference for identity management";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-21.11";

  outputs = { self, nixpkgs, ... }: {
    devShell = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix
      (system:
        import ./shell.nix {
          pkgs = import nixpkgs { inherit system; };
        }
      );
    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix
      (system:
        {
          identity-foundation-account = import ./identity-foundation-account/shell.nix {
            pkgs = import nixpkgs { inherit system; };
          };
          identity-foundation-app = import ./identity-foundation-app/shell.nix {
            pkgs = import nixpkgs { inherit system; };
          };
          identity-foundation-deployment = import ./identity-foundation-deployment/shell.nix {
            pkgs = import nixpkgs { inherit system; };
          };
          identity-foundation-infrastructure = import ./identity-foundation-infrastructure/shell.nix {
            pkgs = import nixpkgs { inherit system; };
          };

        });
  };
}
