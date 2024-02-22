{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    fenix,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [
          fenix.packages.${system}.complete.toolchain
          pkgs.mold
        ];
        RUSTFLAGS = "-Clink-arg=-fuse-ld=mold";
        shellHook = ''
          echo "Welcome to Chauhan's Rust Development Shell"
          exec nu
        '';
      };
    });
}
