{
  description = "Python API for YouTube transcripts/subtitles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

      in
      {
        # Development shell - provides Python and Poetry, nothing else
        # All Python dependencies are managed via Poetry (poetry.lock)
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.python3
            pkgs.poetry
          ];

          shellHook = ''
            echo "YouTube Transcript API Development Environment"
            echo "=============================================="
            echo "Python: $(python --version)"
            echo "Poetry: $(poetry --version)"
            echo ""
            echo "Getting started:"
            echo "  poetry install --with test,dev"
            echo ""
            echo "Available commands:"
            echo "  poetry run poe test       - Run tests"
            echo "  poetry run poe coverage   - Run coverage"
            echo "  poetry run poe lint       - Run linter"
            echo "  poetry run poe format     - Run formatter"
            echo "  poetry run poe precommit  - Run all checks"
            echo ""
            echo "NOTE: All Python dependencies are managed by Poetry (poetry.lock)."
            echo "      Nix only provides Python and Poetry themselves."
          '';
        };
      }
    );
}
