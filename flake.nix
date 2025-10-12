{
  description = "Terraform environment with Terraform v1.13.3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      terraform_1_13_3 = pkgs.stdenv.mkDerivation {
        name = "terraform-1.13.3";
        src = pkgs.fetchurl {
          url = "https://releases.hashicorp.com/terraform/1.13.3/terraform_1.13.3_linux_amd64.zip";
          sha256 = "71fc43d92ea09907be5d416d2405a6a9c2d1ceaed633f5e175c0af26e8c4b365";
        };
        buildInputs = [ pkgs.unzip ];
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
          echo "Welcome!"
          terraform version
        '';
      };
    };
}
