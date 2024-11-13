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
  inputs.puredata.url = "github:enzohideo/puredata-nix";

  outputs = { ... }@inputs: {
    devShells = inputs.puredata.devShells;
  };
}
```

### Ofelia/abs on Wayland

Ofelia seems to segfault on wayland when using objects from ofelia/abs. As a
temporary workaround, you can use gamescope.

```nix
{
  inputs.puredata.url = "github:enzohideo/puredata-nix";

  outputs = { ... }@inputs: let
    system = "x86_64-linux";
    pkgs = inputs.puredata.inputs.nixpkgs.legacyPackages.${system};
    ofelia = inputs.puredata.packages.${system}.ofelia;
  in {
    devShells.${system}.default = pkgs.mkShell {
      inputsFrom = [
        inputs.puredata.devShells.${system}.compmus
      ];

      buildInputs = with pkgs; [
        gamescope
      ];

      shellHook = ''
        # you need to specify the path to ofelia/abs
        gamescope -- pd -path "${ofelia}/ofelia/abs"
        exit
      '';
    };
  };
}
```

You might need to change the pkgs input to avoid version mismatch between
gamescope's and your system's mesa.

> [!NOTE]
> The default dev shell can be started with `nix develop`
