{
  description = "Run environment for dawn vulkan";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
  };

  outputs = { self, nixpkgs }: 
  let 
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    
    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Nixpkgs instantiated for supported system types.
    pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in
  {
    devShells = forAllSystems (system: {
      default =
        pkgsFor.${system}.mkShell.override {
          stdenv = pkgsFor.${system}.gcc14Stdenv;
        } {

          name = "vulkan-dev-shell";
          hardeningDisable = ["all"];
          packages = with pkgsFor.${system}; [
            libz                    # needed for assimp
            stdenv.cc.cc.lib        # libc
            pkg-config
            cmake
            emscripten
            vulkan-tools
            vulkan-headers
            vulkan-loader
            vulkan-validation-layers
          ];
          shellHook = ''
              zsh
          '';

          LD_LIBRARY_PATH="${pkgsFor.${system}.libz}/lib:${pkgsFor.${system}.stdenv.cc.cc.lib}/lib:${pkgsFor.${system}.vulkan-tools}/lib:${pkgsFor.${system}.vulkan-headers}/lib:${pkgsFor.${system}.vulkan-loader.dev}:${pkgsFor.${system}.vulkan-validation-layers}/lib";
          VULKAN_SDK="${pkgsFor.${system}.vulkan-loader}/lib";
          VK_LAYER_PATH="${pkgsFor.${system}.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
        };
    });
  };
}
