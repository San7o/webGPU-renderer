{
  description = "Development environment for webGPU";

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

          name = "ecs-dev-shell";
          hardeningDisable = ["all"];
          packages = with pkgsFor.${system}; [
            libz                    # needed for assimp
            stdenv.cc.cc.lib        # libc
            cmake                   # build system
            xorg.libXrandr.dev
            xorg.libXinerama.dev
            xorg.libXcursor.dev
            mesa.dev
            pkg-config
            wayland-scanner.dev
            libxkbcommon.dev
            glfw-wayland-minecraft
            libxkbcommon
            libGLU.dev
            vulkan-tools
            vulkan-headers
            vulkan-loader
          ];
          shellHook = ''
              zsh
          '';

          LD_LIBRARY_PATH="${pkgsFor.${system}.libz}/lib:${pkgsFor.${system}.xorg.libXrandr.dev}:${pkgsFor.${system}.xorg.libXinerama.dev}:${pkgsFor.${system}.xorg.libXcursor.dev}:${pkgsFor.${system}.mesa.dev}:${pkgsFor.${system}.pkg-config}/bin:${pkgsFor.${system}.wayland-scanner.dev}:${pkgsFor.${system}.libxkbcommon.dev}:${pkgsFor.${system}.libGLU}:${pkgsFor.${system}.wayland}/lib:${pkgsFor.${system}.libxkbcommon}/lib:${pkgsFor.${system}.vulkan-headers}/lib:${pkgsFor.${system}.vulkan-loader}/lib";
        };
    });
  };
}
