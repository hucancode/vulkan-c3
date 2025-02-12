# Vulkan Bindings for C3

## Installation

Copy `vulkan.c3l` to your project's `lib` folder and you are good to go. In your code file, import the library
```
import vk;
```
If you are using GLFW, you may need to turn on a flag to enable vulkan support on GLFW
```
module std::core::env;
const bool GLFW_INCLUDE_VULKAN = true;
```

## Usage

* Vulkan functions are renamed as follows: `vkFunctionName` -> `vk::functionName`
* Vulkan constants are renamed as follows: `VK_CONSTANT_NAME` -> `vk::CONSTANT_NAME`
* Vulkan structs are renamed as follows: `VkStructName` -> `vk::StructName`
* Vulkan enums are renamed as follows: `VkEnumName` -> `vk::EnumName`
  * Enum values are renamed as follows: `VK_ENUM_VALUE` -> `vk::ENUM_VALUE`
* Vulkan flags are converted to `bitstruct` and renamed as follows: `VkFlagName` -> `vk::FlagName`
* All string equivalents (e.g. `char *`) are converted to `ZString`
* Array (e.g `VkPhysicalDevice*`) are renamed as follows: `VkStructName*` -> `vk::StructName`, they are not converted into `C3` arrays or slices. You need to handle them manually like you do in `C`

## Error Handling

All functions that return a `VkResult` will be kept as is, but you can convert it into an `Optional` using `vk::check`

You can handle errors manually like this:
```cpp
fn void create() {
    vk::Result result = vk::createInstance(&createInfo, null, &instance);
    if (result != vk::Result::Success) {
        io::printfn("Failed to create instance");
    }
}
```
Or you can use `C3` idiom like this:
```cpp
fn void! create() {
    vk::check(vk::createInstance(&createInfo, null, &instance))!;
}
```

# Credits

This binding was mostly generated using a python script based on [Odin](https://github.com/odin-lang/Odin/tree/master/vendor/vulkan)'s.
