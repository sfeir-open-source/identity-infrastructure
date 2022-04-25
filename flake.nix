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
          identityFoundationAccount = import ./identity-foundation-account/shell.nix {
            pkgs = import nixpkgs { inherit system; };
          };
          identityFoundationApp = import ./identity-foundation-app/shell.nix {
            pkgs = import nixpkgs { inherit system; };
          };
          identityFoundationFactory = import ./identity-foundation-factory/shell.nix {
            pkgs = import nixpkgs { inherit system; };
          };
          identityFoundationInfrastructure = import ./identity-foundation-infrastructure/shell.nix {
            pkgs = import nixpkgs { inherit system; };
          };
          identityFoundationOathkeeper = import ./identity-foundation-oathkeeper/shell.nix {
            pkgs = import nixpkgs { inherit system; };
          };
        });
  };
}
