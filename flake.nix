{
  description = "dwm-flexipatch";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      systems = lib.systems.flakeExposed;
      eachSystem = function: lib.genAttrs systems (system: function (pkgs system));
      pkgs = system: nixpkgs.legacyPackages.${system}.extend self.overlays.default;
    in
    {
      overlays.default = _: prev: {
        dwm-flexipatch = pkgs.dwm.overrideAttrs (old: {
          src = ./dwm;
          buildInputs =
            old.buildInputs
            ++ builtins.attrsValues {
              inherit (prev)
                libxcursor
                imlib2
                libxrender
                libxext
                ;
            };
        });
      };

      packages = eachSystem (pkgs: {
        inherit (pkgs) dwm-flexipatch;
      });
    };
}
