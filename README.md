# Vulkan Bindings for C3

## Installation

Copy `vulkan.c3l` to your project's `lib` folder and you are good to go. In your code file, import the library
```cpp
import vk;
```
If you are using GLFW, you may need to turn on a flag to enable vulkan support on GLFW
```cpp
module std::core::env;
const bool GLFW_INCLUDE_VULKAN = true;
import glfw;
```

# Running example
Install C3C, Vulkan SDK, GLFW.
Compile Shader
```sh
glslc src/shaders/shader.frag -o src/shaders/frag.spv
glslc src/shaders/shader.vert -o src/shaders/vert.spv
```
Then run
```sh
c3c run
```
If you don't want to install those dependencies on your system, you can use a nix flake to set them up for you
```sh
nix develop
# inside nix environment
glslc src/shaders/shader.frag -o src/shaders/frag.spv
glslc src/shaders/shader.vert -o src/shaders/vert.spv
c3c run
```

![screenshot](docs/cube.gif)

## Usage
| Use case                                               | C                                              | C3 Equivalent                                           |
|-----------------------------------------------------------|------------------------------------------------------------------|----------------------------------------------------------------|
| Function naming                                           | `vkFunctionName`                                                 | `vk::functionName`                                             |
| Constant naming                                           | `VK_CONSTANT_NAME`                                               | `vk::CONSTANT_NAME`                                            |
| Struct naming                                             | `VkStructName`                                                   | `vk::StructName`                                               |
| Enum type                                          | `VkEnumName`                                                     | `vk::EnumName`                                                 |
| Enum value                                         | `VK_ENUM_VALUE`                                                  | `vk::ENUM_VALUE`                                               |
| Flag type                                      | `VkFlagName`                                                     | `vk::FlagName` as `bitstruct`                                  |
| Error type                                      | `VK_ERROR_NOT_READY`                                                     | `vk::error::NOT_READY`                                  |
| String type                                    | `char *`                                                         | `ZString`                                                      |
| Error handling                                    | `VkResult vkBeginCommandBuffer(VkCommandBuffer, const VkCommandBufferBeginInfo*)` | `fn void? beginCommandBuffer(CommandBuffer, CommandBufferBeginInfo*)` |
| Array extraction                         | `VkResult VkEnumerateInstanceExtensionProperties(char*, int*, VkExtensionProperties*)` | `fn ExtensionProperties[]? enumerateInstanceExtensionProperties(ZString)` |
| Value extraction                        | `VkResult vkCreateInstance(const VkInstanceCreateInfo*, const VkAllocationCallbacks*, VkInstance*)` | `fn Instance? createInstance(InstanceCreateInfo*, AllocationCallbacks* = null)` |

## Error Handling

You can handle errors manually like this:
```cpp
vk::ApplicationInfo app_info = {
    .s_type = vk::STRUCTURE_TYPE_APPLICATION_INFO,
    .p_application_name = "Fortknight",
    .application_version = vk::@make_version(1, 0, 0),
    .p_engine_name = "Soreal Engine",
    .engine_version = vk::@make_version(1, 0, 0),
    .api_version = vk::API_VERSION_1_3,
};
vk::InstanceCreateInfo createInfo = {
    .s_type = vk::STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
    .p_application_info = &app_info,
};

fn void create() {
    Instance? instance = vk::createInstance(&createInfo);
    if (catch excuse = instance) {
        if (excuse == vk::error::NOT_READY) {
            io::printfn("not ready to create instance");
        } else {
            io::printfn("something went wrong while creating instance");
        }
    }
    // continue using instance
}
```
Or you can use shorthand like so:
```cpp
fn void create() {
    Instance instance = vk::createInstance(&createInfo)!!; // immediate crash on error
}
```

# Enum handling
Enum is implemented as follow
```cpp
typedef  IndexType = CInt;
const IndexType INDEX_TYPE_UINT16    = 0;
const IndexType INDEX_TYPE_UINT32    = 1;
const IndexType INDEX_TYPE_UINT8     = 1000265000;
const IndexType INDEX_TYPE_NONE_KHR  = 1000165000;
const IndexType INDEX_TYPE_NONE_NV   = INDEX_TYPE_NONE_KHR;
const IndexType INDEX_TYPE_UINT8_EXT = INDEX_TYPE_UINT8;
const IndexType INDEX_TYPE_UINT8_KHR = INDEX_TYPE_UINT8;

vk::cmdBindIndexBuffer(command_buffer, buffer, 0, vk::INDEX_TYPE_UINT8); // OK
```

Note: In C3 the following code is more idiomatic and clean, but it is not compatible with Vulkan C library.
With this implementation `vk::IndexType.UINT8` will be passed as `2` to vulkan instead of the expected `1000265000`
```cpp
enum IndexType : CInt (inline CInt v) {
    UINT16    = 0,
    UINT32    = 1,
    UINT8     = 1000265000,
    NONE_KHR  = 1000165000,
    NONE_NV   = 1000165000,
    UINT8_EXT = 1000265000,
    UINT8_KHR = 1000265000,
}

vk::cmdBindIndexBuffer(command_buffer, buffer, 0, vk::IndexType.UINT8); // this will cause GPU to read trash values!!
```

# Credits

This binding was made possible thank to the initial effort from [Odin](https://github.com/odin-lang/Odin/tree/master/vendor/vulkan)'s.
