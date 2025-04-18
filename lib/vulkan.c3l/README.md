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

* Vulkan functions are renamed as follows: `vkFunctionName` -> `vk::functionName`
* Vulkan constants are renamed as follows: `VK_CONSTANT_NAME` -> `vk::CONSTANT_NAME`
* Vulkan structs are renamed as follows: `VkStructName` -> `vk::StructName`
* Vulkan enums are renamed as follows: `VkEnumName` -> `vk::EnumName`
  * Enum values are renamed as follows: `VK_ENUM_VALUE` -> `vk::ENUM_VALUE`
* Vulkan flags are converted to `bitstruct` and renamed as follows: `VkFlagName` -> `vk::FlagName`
* All string equivalents (e.g. `char *`) are converted to `ZString`
* All functions that handle error by returning `VkResult` is now converted to using C3's `fault` system. For example `VkResult vkBeginCommandBuffer(VkCommandBuffer commandBuffer, const VkCommandBufferBeginInfo* pBeginInfo)` is converted to `fn void? beginCommandBuffer(CommandBuffer commandBuffer, CommandBufferBeginInfo* pBeginInfo)`
* All functions that supposed to extract an array values are converted to return a `slice` instead. For example `VkResult VkEnumerateInstanceExtensionProperties(char* pLayerName, int* count, VkExtensionProperties* properties)` is converted to `fn ExtensionProperties[]? enumerateInstanceExtensionProperties(ZString pLayerName)`
* All functions that supposed to return a value now return that value and not take the output in function argument in the form of pointer. For example `VkResult vkCreateInstance(const VkInstanceCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkInstance* pInstance)` is converted to `fn Instance? createInstance(InstanceCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator = null)`

## Error Handling

You can handle errors manually like this:
```cpp
vk::InstanceCreateInfo createInfo = {
    .s_type = vk::STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
    .p_application_info = &&vk::ApplicationInfo {
        .s_type = vk::STRUCTURE_TYPE_APPLICATION_INFO,
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
