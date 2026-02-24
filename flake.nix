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
        
        # Build the package using poetry2nix
        youtube-transcript-api = pkgs.python3Packages.buildPythonApplication {
          pname = "youtube-transcript-api";
          version = "1.2.4";
          format = "pyproject";

          src = ./.;

          nativeBuildInputs = with pkgs.python3Packages; [
            poetry-core
          ];

          propagatedBuildInputs = with pkgs.python3Packages; [
            requests
            defusedxml
          ];

          # Test dependencies (optional, uncomment if you want to run tests during build)
          # nativeCheckInputs = with pkgs.python3Packages; [
          #   pytest
          #   coverage
          #   httpretty
          # ];

          # Disable tests for now (can enable with nativeCheckInputs)
          doCheck = false;

          # Disable runtime dependency version checks (nixpkgs may have newer versions)
          dontCheckRuntimeDeps = true;

          meta = with pkgs.lib; {
            description = "Python API for retrieving YouTube video transcripts/subtitles";
            homepage = "https://github.com/jdepoix/youtube-transcript-api";
            license = licenses.mit;
            maintainers = [ ];
            mainProgram = "youtube_transcript_api";
          };
        };

      in
      {
        # The package
        packages = {
          default = youtube-transcript-api;
          youtube-transcript-api = youtube-transcript-api;
        };

        # The app (CLI)
        apps = {
          default = {
            type = "app";
            program = "${youtube-transcript-api}/bin/youtube_transcript_api";
          };
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python
            poetry
            
            # Development tools
            python3Packages.pytest
            python3Packages.coverage
            python3Packages.httpretty
            python3Packages.ruff
          ];

          shellHook = ''
            echo "🎬 YouTube Transcript API Development Environment"
            echo "================================================"
            echo "Python: $(python --version)"
            echo "Poetry: $(poetry --version)"
            echo ""
            echo "Available commands:"
            echo "  poetry install      - Install dependencies"
            echo "  poetry run poe test - Run tests"
            echo "  poetry shell        - Activate poetry virtualenv"
            echo ""
            echo "Or use Nix commands:"
            echo "  nix build           - Build the package"
            echo "  nix run             - Run the CLI"
            echo "  nix develop         - Enter dev shell (you're here!)"
          '';
        };
      }
    );
}
