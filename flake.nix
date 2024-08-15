{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-boost.url = "nixpkgs/nixos-23.05";
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
  in {
    packages = eachSystem (system: let
      pkgs = pkgsFor.${system};
    in builtins.mapAttrs (name: value: pkgs.callPackage ./packages/${name} value) {
      ggee = {};
      iemguts = {};
      iemlib = {};
      ofelia = {
        boost = inputs.nixpkgs-boost.legacyPackages.${system}.boost174;
      };
      windowing = {};
    });

    devShells = eachSystem (system: let
      pkgs = pkgsFor.${system};
    in {
      default = self.devShells.${system}.compmus;
      compmus = pkgs.mkShell {
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
