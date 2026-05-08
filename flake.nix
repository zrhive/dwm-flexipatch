{
  description = "dwm-flexipatch";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      systems = lib.systems.flakeExposed;
      eachSystem = function: lib.genAttrs systems (system: function (pkgs system));
      pkgs = system: nixpkgs.legacyPackages.${system};
    in
    {
      packages = eachSystem (pkgs: {
        dwm-flexipatch = pkgs.dwm.overrideAttrs (old: {
          src = ./dwm;
          buildInputs =
            old.buildInputs
            ++ builtins.attrsValues {
              inherit (pkgs)
                libxcursor
                imlib2
                libxrender
                libxext
                ;
            };
        });
      });
    };
}
