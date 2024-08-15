# puredata-nix

Pure Data externals for Nix and NixOS.

### Externals

- ggee
- iemguts
- iemlib
- ofelia
- windowing

### Usage with flakes

Manually pick which externals you want to use

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    puredata.url = "github:enzohideo/puredata-nix";
  };

  outputs = { ... }@inputs: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        (pkgs.puredata-with-plugins (with pkgs; [
          cyclone
          zexy
        ] ++ (with inputs.puredata.packages.${system}; [
          ggee
          iemguts
          iemlib
          ofelia
          windowing
        ])))
      ];
    };
  };
}
```

Or use the example dev shell provided by this flake

```nix
{
  inputs = {
    puredata.url = "github:enzohideo/puredata-nix";
  };

  outputs = { ... }@inputs: {
    devShells = inputs.puredata.devShells;
  };
}
```

> [!NOTE]
> The default dev shell can be started with `nix develop`
