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

## Usage

| Use case         | C                                                                                                   | C3 Equivalent                                                                   |
| ---------------- | --------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Function naming  | `vkFunctionName`                                                                                    | `vk::functionName`                                                              |
| Constant naming  | `VK_CONSTANT_NAME`                                                                                  | `vk::CONSTANT_NAME`                                                             |
| Struct naming    | `VkStructName`                                                                                      | `vk::StructName`                                                                |
| Enum type        | `VkEnumName`                                                                                        | `vk::EnumName`                                                                  |
| Enum value       | `VK_ENUM_NAME_VALUE`                                                                                | `vk::EnumName.VALUE`                                                            |
| Flag type        | `VkFlagName`                                                                                        | `vk::FlagName` as `bitstruct`                                                   |
| Error type       | `VK_ERROR_NOT_READY`                                                                                | `vk::error::NOT_READY`                                                          |
| String type      | `char *`                                                                                            | `ZString`                                                                       |
| Error handling   | `VkResult vkBeginCommandBuffer(VkCommandBuffer, const VkCommandBufferBeginInfo*)`                   | `fn void? beginCommandBuffer(CommandBuffer, CommandBufferBeginInfo*)`           |
| Array extraction | `VkResult VkEnumerateInstanceExtensionProperties(char*, int*, VkExtensionProperties*)`              | `fn ExtensionProperties[]? enumerateInstanceExtensionProperties(ZString)`       |
| Value extraction | `VkResult vkCreateInstance(const VkInstanceCreateInfo*, const VkAllocationCallbacks*, VkInstance*)` | `fn Instance? createInstance(InstanceCreateInfo*, AllocationCallbacks* = null)` |

## Error Handling

You can handle errors manually like this:
```cpp
vk::InstanceCreateInfo createInfo = {
    .s_type = vk::StructureType.INSTANCE_CREATE_INFO,
    .p_application_info = &&vk::ApplicationInfo {
        .s_type = vk::StructureType.APPLICATION_INFO,
        .p_application_name = "Hello",
        .application_version = vk::@make_version(1, 0, 0),
        .p_engine_name = "Soreal Engine",
        .engine_version = vk::@make_version(1, 0, 0),
        .api_version = vk::API_VERSION_1_3,
    },
};
fn void create() {
    Instance? instance = vk::createInstance(&createInfo);
    if (catch excuse == instance) {
        if (excuse == vk::Error::NOT_READY) {
            io::printfn("not ready to create instance");
        } else {
            io::printfn("something went wrong while creating instance");
        }
    }
}
```
Or you can use shorthand like so:
```cpp
fn void create() {
    Instance instance = vk::createInstance(&createInfo)!!;
}
```
# Credits

This binding was made possible thank to the initial effort from [Odin](https://github.com/odin-lang/Odin/tree/master/vendor/vulkan)'s.
