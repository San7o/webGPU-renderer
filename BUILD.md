# Build dawn

Down is a quite large project, to install the dependencies on nix, use the developement shell located in `files`.

For wayland, you need to compile with the following flags:
```bash
cmake -Bbuild -DDAWN_USE_WAYLAND=ON -DDAWN_USE_X11=OFF -DDAWN_FETCH_DEPENDENCIES=ON -DDAWN_ENABLE_INSTALL=ON -DCMAKE_BUILD_TYPE=Release
```

After building, install the library where you want:
```bash
cmake --install build --prefix install_dir
```

This repo contains a prebuilt version of dawn in `lib64`.

# Vulkan

You need vulkan on linux to use dawn, you can enter the developement shell on nix with:
```bash
nix develop
```

You will need to copy `libvulkan.so` to `./libs64`

# Build the demo

```bash
cmake -Bbuild
cmake --build build
./build/App
```
