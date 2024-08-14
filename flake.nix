{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-boost.url = "nixpkgs/nixos-21.05";
    nixpkgs-glew.url = "nixpkgs/nixos-20.03";
  };

  outputs = { self, nixpkgs, systems, ... }@inputs : let
    inherit (nixpkgs) lib;
    eachSystem = lib.genAttrs (import systems);
    pkgsFor = eachSystem (system: import nixpkgs {
      inherit system;
      config = {
        permittedInsecurePackages = [
          # Known issues:
          #  - CVE-2021-33367
          #  - CVE-2021-40262
          #  - CVE-2021-40263
          #  - CVE-2021-40264
          #  - CVE-2021-40265
          #  - CVE-2021-40266
          #  - CVE-2023-47992
          #  - CVE-2023-47993
          #  - CVE-2023-47994
          #  - CVE-2023-47995
          #  - CVE-2023-47996
          "freeimage-unstable-2021-11-01"
        ];
      };
    });
    boostFor = eachSystem (system: (import inputs.nixpkgs-boost {
      inherit system;
    }).boost171);
    glewFor = eachSystem (system: (import inputs.nixpkgs-glew {
      inherit system;
    }).glew);
  in {
    packages = eachSystem (system: let
      pkgs = pkgsFor.${system};
    in builtins.mapAttrs (name: value: pkgs.callPackage ./packages/${name} value) {
      ggee = {};
      iemguts = {};
      iemlib = {};
      ofelia = {
        boost = boostFor.${system};
        glew = glewFor.${system};
      };
      windowing = {};
    });

    devShells = eachSystem (system: let
      pkgs = pkgsFor.${system};
    in {
      default = pkgs.mkShell {
        name = "puredata-shell";
        buildInputs = [
          (pkgs.puredata-with-plugins (with pkgs; [
            cyclone
            zexy
          ] ++ builtins.attrValues self.packages.${system}))
        ];
      };
    });
  }; 
}
