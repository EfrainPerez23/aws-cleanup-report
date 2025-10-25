{
  description = "Terraform environment with Terraform v1.13.3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      python = pkgs.python313;
      pythonEnv = python.withPackages (ps: with ps; [ pip virtualenv ]);

      terraform_1_13_3 = pkgs.stdenv.mkDerivation {
        name = "terraform-1.13.3";
        src = pkgs.fetchurl {
          url = "https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_linux_amd64.zip";
          sha256 = "71fc43d92ea09907be5d416d2405a6a9c2d1ceaed633f5e175c0af26e8c4b365";
        };
        buildInputs = [
          pkgs.unzip
          pythonEnv
        ];
        unpackPhase = ":";

        installPhase = ''
          mkdir -p $out/bin
          unzip $src -d $out/bin
          chmod +x $out/bin/terraform
        '';
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          terraform_1_13_3
          pkgs.git
          pkgs.gnumake
        ];

        shellHook = ''
          VENV_DIR=".venv"

          if [ ! -d "$VENV_DIR" ]; then
            echo ">>> Creando entorno virtual en $VENV_DIR..."
            ${python.interpreter} -m venv $VENV_DIR
            source $VENV_DIR/bin/activate
            echo ">>> Instalando dependencias..."
            pip install --upgrade pip
          else
            source $VENV_DIR/bin/activate
          fi

          if [ -f requirements.txt ]; then
            pip install -r requirements.txt
          fi
          echo -e "\nEntorno virtual activado."
          echo "Welcome!"
          terraform version
          echo "Python: $(python --version)"
        '';
      };
    };
}
