module mj::vkbe;
import std::core::mem;
import std::io;
import vk;
import glfw;


fn void! createVulkanInstance() {
    vk::loadProcAddressesGlobal(&glfw::getInstanceProcAddress);
    ulong extensionCount;
    ZString* glfwExtensions = glfw::getRequiredInstanceExtensions(&extensionCount);
    ZString* extensions = (ZString*)malloc(extensionCount * ZString.sizeof);
    mem::copy(extensions, glfwExtensions, extensionCount * ZString.sizeof);
    defer free(extensions);
    vk::InstanceCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .p_application_info = &&vk::ApplicationInfo {
            .s_type = vk::STRUCTURE_TYPE_APPLICATION_INFO,
            .p_application_name = TITLE,
            .application_version = vk::@make_version(1, 0, 0),
            .p_engine_name = ENGINE_NAME,
            .engine_version = vk::@make_version(1, 0, 0),
            .api_version = vk::API_VERSION_1_3,
        },
    };
    $if env::DARWIN:
        // Mandatory on macOS
        createInfo.flags.enumerate_portability_khr = true;
        extensionCount++;
        extensions = (ZString*)realloc(extensions, extensionCount * ZString.sizeof);
        extensions[extensionCount - 1] = vk::KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME;
    $endif

    $if ENABLE_VALIDATION_LAYERS:
        createInfo.enabled_layer_count = VALIDATION_LAYERS.len;
        createInfo.pp_enabled_layer_names = &VALIDATION_LAYERS;
        extensionCount++;
        extensions = (ZString*)realloc(extensions, extensionCount * ZString.sizeof);
        extensions[extensionCount - 1] = vk::EXT_DEBUG_UTILS_EXTENSION_NAME;
        vk::DebugUtilsMessengerCreateInfoEXT debugCreateInfo = {
            .s_type = vk::STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
            .message_severity = vk::DebugUtilsMessageSeverityFlagsEXT { .error, .warning, .info },
            .message_type = vk::DebugUtilsMessageTypeFlagsEXT { .general, .validation, .performance, .device_address_binding },
            .pfn_user_callback = fn uint(vk::DebugUtilsMessageSeverityFlagsEXT messageSeverity,
                vk::DebugUtilsMessageTypeFlagsEXT messageType,
                vk::DebugUtilsMessengerCallbackDataEXT* pCallbackData,
                void* pUserData) {
                return 0;
            },
        };
        createInfo.p_next = &debugCreateInfo;
    $endif

    createInfo.enabled_extension_count = (uint)extensionCount;
    createInfo.pp_enabled_extension_names = extensions;
    io::printfn("Required extensions count: %d", (uint)extensionCount);
    for (uint i = 0; i < extensionCount; i++) {
        io::printfn("Required extension: %s", extensions[i]);
    }
    vk::createInstance(&createInfo, null, &g_instance)!;
    vk::loadProcAddressesInstance(g_instance);
    $if ENABLE_VALIDATION_LAYERS:
        vk::createDebugUtilsMessengerEXT(
            g_instance,
            &debugCreateInfo,
            null,
            &g_debug_messenger
        )!;
    $endif
}

fn void destroyVulkanInstance() {
    $if ENABLE_VALIDATION_LAYERS:
        vk::destroyDebugUtilsMessengerEXT(g_instance, g_debug_messenger, null);
    $endif
    vk::destroyInstance(g_instance, null);
}
