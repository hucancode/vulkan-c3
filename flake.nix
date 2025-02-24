{
  description = "A Nix-flake-based C/C++ development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    c3c.url = "github:c3lang/c3c?tag=0.6.7";
  };

  outputs = { self, nixpkgs, c3c }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
        c3cPkg = c3c.packages.${system}.default or null;
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, c3cPkg }: {
        default = pkgs.mkShell.override
          { }
          {
            packages = with pkgs; [
              glfw
              freetype
              vulkan-loader
              gnumake
              shaderc
              tracy
            ] ++ (if system == "x86_64-darwin" || system == "aarch64-darwin" then [ moltenvk ] else [ vulkan-validation-layers ])
            ++ (if c3cPkg != null then [ c3cPkg ] else [ ]);
          };
      });
    };
}
