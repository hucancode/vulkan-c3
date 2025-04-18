{
  description = "A Nix-flake-based C/C++ development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell.override
          { }
          {
            packages = with pkgs; [
              glfw
              freetype
              vulkan-loader
              shaderc
              tracy
              c3c
            ] ++ (if system == "x86_64-darwin" || system == "aarch64-darwin" then [ moltenvk ] else [ vulkan-validation-layers ]);
          };
      });
    };
}
