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
        python = pkgs.python3;
        
        # Python environment with dependencies from pyproject.toml
        pythonEnv = python.withPackages (ps: with ps; [
          requests
          defusedxml
          # Dev dependencies
          pytest
          coverage
          httpretty
          ruff
        ]);

      in
      {
        # Development shell - this is the main use case for contributors
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.poetry
            pythonEnv
          ];

          shellHook = ''
            echo "YouTube Transcript API Development Environment"
            echo "=============================================="
            echo "Python: $(python --version)"
            echo "Poetry: $(poetry --version)"
            echo ""
            echo "Setup:"
            echo "  poetry install --with test,dev"
            echo ""
            echo "Available commands:"
            echo "  poetry run poe test       - Run tests"
            echo "  poetry run poe coverage   - Run coverage"
            echo "  poetry run poe lint       - Run linter"
            echo "  poetry run poe format     - Run formatter"
            echo "  poetry run poe precommit  - Run all checks"
            echo ""
            echo "Note: Dependencies are managed via Poetry (poetry.lock)"
            echo "      Nix provides the base Python and Poetry itself"
          '';
        };
      }
    );
}
