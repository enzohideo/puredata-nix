# puredata-nix

Pure Data externals for Nix and NixOS.

### Externals

- ggee
- iemguts
- iemlib
- ofelia
- windowing

### Usage

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
