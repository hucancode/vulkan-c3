# Vulkan C3 Binding

This is a Vulkan binding for `C3`. On the details of how to include this library in your project, see [vulkan.c3l](./lib/vulkan.c3l/README.md)

![](./readme/cube.gif)

# Installation
## Manual
To build example program we need
- [C3](https://c3-lang.org)
- [GLFW](https://www.glfw.org)
- [Vulkan SDK](https://vulkan.lunarg.com/sdk/home)
- [make](https://www.gnu.org/software/make)

If you are on Arch Linux you can install them all using
```sh
sudo pacman -S c3c glfw vulkan-devel make
```
## Nix
Alternately you can use [Nix](https://nixos.org) to simplify the installation process
After install Nix, run to enter development environment
```sh
make develop
```

# Running
Simply run `make` to run the program. Or if you want debug build, run
```sh
make debug
```
