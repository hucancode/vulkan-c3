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
* All functions that handle error by returning `VkResult` is now converted to using C3's `fault` system. For example `VkResult vkCreateInstance(const VkInstanceCreateInfo* pCreateInfo, const VkAllocationCallbacks* pAllocator, VkInstance* pInstance)` is converted to `voi! createInstance(InstanceCreateInfo* pCreateInfo, AllocationCallbacks* pAllocator, Instance* pInstance)`
* All functions that supposed to extract an array values are converted to return a `slice` instead. For example `VkResult VkEnumerateInstanceExtensionProperties(char* pLayerName, int* count, VkExtensionProperties* properties)` is converted to `ExtensionProperties[]! enumerateInstanceExtensionProperties(ZString pLayerName)`

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
    anyfault excuse = vk::createInstance(&createInfo, null, &instance);
    if (excuse == vk::Error::NOT_READY) {
        io::printfn("not ready to create instance");
    }
}
```
Or you can use shorthand like so:
```cpp
fn void create() {
    vk::createInstance(&createInfo, null, &instance)!!;
}
```

# Credits

This binding was mostly generated using a python script based on [Odin](https://github.com/odin-lang/Odin/tree/master/vendor/vulkan)'s.
