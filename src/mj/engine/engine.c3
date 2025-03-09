module mj;
import std::time;
import std::math::matrix;
import std::math;
import vk;

const ENGINE_NAME = "Mjolnir";
const TITLE = "Vulkan C3";
const ZString[*] REQUIRED_EXTENSIONS = {
    vk::KHR_SWAPCHAIN_EXTENSION_NAME,
    vk::KHR_DYNAMIC_RENDERING_EXTENSION_NAME,
};
const ENABLE_VALIDATION_LAYERS = false;
const ZString[*] VALIDATION_LAYERS @if(ENABLE_VALIDATION_LAYERS) = {
    "VK_LAYER_KHRONOS_validation",
};

struct Engine {
    glfw::Window* window;
    vk::Instance instance;
    vk::DebugUtilsMessengerEXT debug_messenger @if(ENABLE_VALIDATION_LAYERS);
    vk::SurfaceKHR surface;
    vk::PhysicalDevice physical_device;
    vk::Device device;
    vk::Queue graphics_queue;
    vk::Queue present_queue;
    vk::SurfaceFormatKHR swap_chain_format;
    vk::Extent2D swap_chain_extent;
    vk::SwapchainKHR swap_chain;
    vk::Image[] swap_chain_images;
    vk::ImageView[] swap_chain_image_views;
    vk::CommandPool command_pool;
}

fn Engine! Engine.init(Engine* engine, glfw::Window* window) {
    engine.window = window;
    engine.createVulkanInstance()!;
    engine.createWindowSurface()!;
    engine.pickPhysicalDevice()!;
    engine.createLogicalDevice()!;
    engine.createSwapchain()!;
    engine.createSemaphores()!;
    engine.createCommandPool()!;
    return engine;
}

fn void Engine.destroy(Engine* engine) {
    vk::deviceWaitIdle(engine.device)!!;
    engine.destroySwapchain();
    engine.destroySemaphores();
    engine.destroyCommandPool();
    engine.destroyDevice();
    engine.destroySurface();
    engine.destroyVulkanInstance();
}

fn void! Engine.createVulkanInstance(Engine* engine) {
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
    engine.instance = vk::createInstance(&createInfo)!;
    vk::loadProcAddressesInstance(engine.instance);
    $if ENABLE_VALIDATION_LAYERS:
        engine.debug_messenger = vk::createDebugUtilsMessengerEXT(&engine.instance, &debugCreateInfo)!;
    $endif
}

fn void Engine.destroyVulkanInstance(Engine* engine) {
    $if ENABLE_VALIDATION_LAYERS:
        vk::destroyDebugUtilsMessengerEXT(engine.instance, engine.debug_messenger);
    $endif
    vk::destroyInstance(engine.instance);
}

fn void! Engine.createWindowSurface(Engine* engine) {
    vk::check(glfw::createWindowSurface(engine.instance, engine.window, null, &engine.surface))!;
}

fn void Engine.destroySurface(Engine* engine) {
    vk::destroySurfaceKHR(engine.instance, engine.surface);
}

fn uint scorePhysicalDevice(vk::PhysicalDevice device) {
    uint score = 0;
    vk::PhysicalDeviceProperties properties = vk::getPhysicalDeviceProperties(device);
    vk::PhysicalDeviceFeatures features = vk::getPhysicalDeviceFeatures(device);
    ZString deviceName = (ZString)properties.device_name[0..];
    io::printfn("Scoring device %s", deviceName);
    defer io::printfn("Device %s scored %d", score);
    $if !env::DARWIN:
        if (!features.geometry_shader) {
            return 0;
        }
    $endif
    vk::ExtensionProperties[]! extensions = vk::enumerateDeviceExtensionProperties(device);
    if (catch excuse = extensions) {
        io::printfn("Cound not get extension list for %s", deviceName);
        return 0;
    }
    defer free(extensions);
    foreach (e:extensions) {
        io::printfn("Extension %s", (ZString)e.extension_name[0..]);
    }
    foreach (required: REQUIRED_EXTENSIONS) {
        bool found = false;
        foreach (e : extensions) {
            ZString name = (ZString)e.extension_name[0..];
            if (name.len() == required.len() && mem::equals(name, required, name.len())) {
                found = true;
                break;
            }
        }
        if (!found) {
            io::printfn("Extension %s not found in %s", required, deviceName);
            return 0;
        }
    }
    SwapchainSupportDetails! support = querySwapchainSupport(device);
    if (catch excuse = support) {
        io::printfn("Cound not get swapchain support for %s", deviceName);
        return 0;
    }
    support.free();
    QueueFamilyIndices! indices = findQueueFamilies(device);
    if (catch excuse = indices) {
        io::printfn("Cound not get queue families for %s", deviceName);
        return 0;
    }
    switch (properties.device_type) {
    case vk::PHYSICAL_DEVICE_TYPE_DISCRETE_GPU:
        score += 400_000;
    case vk::PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU:
        score += 300_000;
    case vk::PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU:
        score += 200_000;
    case vk::PHYSICAL_DEVICE_TYPE_CPU:
        nextcase;
    case vk::PHYSICAL_DEVICE_TYPE_OTHER:
        score += 100_000;
    }
    score += properties.limits.max_image_dimension2d;
    return score;
}

fn void! Engine.pickPhysicalDevice(Engine* engine) {
    vk::PhysicalDevice[] devices = vk::enumeratePhysicalDevices(engine.instance)!;
    defer free(devices);
    engine.physical_device = devices[0];
    uint bestScore = 0;
    foreach (device: devices) {
        int score = scorePhysicalDevice(device);
        io::printfn("Device %x score: %d", device, score);
        if (score > bestScore) {
            engine.physical_device = device;
            bestScore = score;
        }
    }
    io::printfn("Selected physical device: %x with score %d", engine.physical_device, bestScore);
}

fn void Engine.destroyDevice(Engine* engine) {
    vk::destroyDevice(engine.device);
}

struct SwapchainSupportDetails {
    vk::SurfaceCapabilitiesKHR capabilities;
    vk::SurfaceFormatKHR[] formats;
    vk::PresentModeKHR[] present_modes;
}
fn void SwapchainSupportDetails.free(SwapchainSupportDetails* self) {
    free(self.formats);
    free(self.present_modes);
}

fn SwapchainSupportDetails! querySwapchainSupport(vk::PhysicalDevice device, vk::SurfaceKHR surface) {
    SwapchainSupportDetails ret;
    ret.capabilities = vk::getPhysicalDeviceSurfaceCapabilitiesKHR(device, surface)!;
    ret.formats = vk::getPhysicalDeviceSurfaceFormatsKHR(device, surface)!;
    ret.present_modes = vk::getPhysicalDeviceSurfacePresentModesKHR(device, surface)!;
    return ret;
}

struct QueueFamilyIndices {
    uint graphics_family;
    uint present_family;
}

fn QueueFamilyIndices! Engine.findQueueFamilies(Engine* engine) {
    vk::QueueFamilyProperties[] families = vk::getPhysicalDeviceQueueFamilyProperties(engine.physical_device);
    QueueFamilyIndices indices;
    bool foundGraphics = false;
    bool foundPresent = false;
    for (uint i = 0; i < families.len; i++) {
        if (families[i].queue_flags.graphics) {
            indices.graphics_family = i;
            foundGraphics = true;
            io::printfn("Queue family %d support graphics", i);
        }
        uint supported = glfw::getPhysicalDevicePresentationSupport(engine.instance, engine.physical_device, i);
        if (supported) {
            indices.present_family = i;
            foundPresent = true;
            io::printfn("Queue family %d support present", i);
        }
        if (foundGraphics && foundPresent) {
            return indices;
        }
    }
    return vk::VulkanError.ERROR_UNKNOWN?;
}

fn void! Engine.createLogicalDevice(Engine* engine) {
    QueueFamilyIndices indices = findQueueFamilies(engine.physical_device)!;
    ZString[] layers;
    $if ENABLE_VALIDATION_LAYERS:
        layers = ZString[*] {
          "VK_LAYER_KHRONOS_validation"
        };
    $endif
    float[*] queue_priorities = {1};
    vk::DeviceQueueCreateInfo queueCreateInfo = {
        .s_type = vk::STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
        .queue_family_index = indices.graphics_family,
        .queue_count = queue_priorities.len,
        .p_queue_priorities = &queue_priorities,
    };
    vk::DeviceCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_DEVICE_CREATE_INFO,
        .queue_create_info_count = 1,
        .p_queue_create_infos = &queueCreateInfo,
        .enabled_extension_count = REQUIRED_EXTENSIONS.len,
        .pp_enabled_extension_names = &REQUIRED_EXTENSIONS,
    };
    $if ENABLE_VALIDATION_LAYERS:
        createInfo.enabled_layer_count = layers.len;
        createInfo.pp_enabled_layer_names = layers.ptr;
    $endif
    engine.device = vk::createDevice(engine.physical_device, &createInfo)!;
    engine.graphic_queue = vk::getDeviceQueue(engine.device, indices.graphics_family, 0);
    engine.present_queue = vk::getDeviceQueue(engine.device, indices.present_family, 0);
}

fn vk::SurfaceFormatKHR pickSwapSurfaceFormat(vk::SurfaceFormatKHR[] formats) {
    foreach (f: formats) {
        if (f.format != vk::FORMAT_B8G8R8A8_SRGB) {
            continue;
        }
        if(f.color_space != vk::COLOR_SPACE_SRGB_NONLINEAR_KHR) {
            continue;
        }
        return f;
    }
    return formats[0];
}

fn vk::PresentModeKHR pickSwapPresentMode(vk::PresentModeKHR[] presentModes) {
    foreach (p: presentModes) {
        if (p == vk::PRESENT_MODE_MAILBOX_KHR) {
            return p;
        }
    }
    return vk::PRESENT_MODE_FIFO_KHR;
}

fn vk::Extent2D pickSwapExtent(vk::SurfaceCapabilitiesKHR capabilities) {
    if (capabilities.current_extent.width != uint.max) {
        return capabilities.current_extent;
    }
    vk::Extent2D actualExtent = {
        .width = 800,
        .height = 600,
    };
    actualExtent.width = max(capabilities.min_image_extent.width, min(capabilities.max_image_extent.width, actualExtent.width));
    actualExtent.height = max(capabilities.min_image_extent.height, min(capabilities.max_image_extent.height, actualExtent.height));
    return actualExtent;
}

fn void! Engine.createSwapchain(Engine* engine) {
    QueueFamilyIndices indices = findQueueFamilies(engine.physical_device)!;
    SwapchainSupportDetails supported = querySwapchainSupport(engine.physical_device)!;
    vk::PresentModeKHR presentMode = pickSwapPresentMode(supported.present_modes);
    engine.swap_chain_format = pickSwapSurfaceFormat(supported.formats);
    engine.swap_chain_extent = pickSwapExtent(supported.capabilities);
    uint count = supported.capabilities.min_image_count + 1;
    bool unlimited = supported.capabilities.max_image_count == 0;
    if (!unlimited && count > supported.capabilities.max_image_count) {
        count = supported.capabilities.max_image_count;
    }
    uint[*] indiceArray = { indices.graphics_family, indices.present_family };
    vk::SwapchainCreateInfoKHR createInfo = {
        .s_type = vk::STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
        .surface = engine.surface,
        .min_image_count = count,
        .image_format = engine.swap_chain_format.format,
        .image_color_space = engine.swap_chain_format.color_space,
        .image_extent = engine.swap_chain_extent,
        .image_array_layers = 1,
        .image_usage = { .color_attachment },
        .image_sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
        .queue_family_index_count = indiceArray.len,
        .p_queue_family_indices = &indiceArray,
        .pre_transform = supported.capabilities.current_transform,
        .composite_alpha = { .opaque },
        .present_mode = presentMode,
        .clipped = vk::TRUE,
    };
    if (indices.graphics_family != indices.present_family) {
        createInfo.image_sharing_mode = vk::SHARING_MODE_CONCURRENT;
        createInfo.queue_family_index_count = indiceArray.len;
        createInfo.p_queue_family_indices = &indiceArray;
    }
    engine.swap_chain = vk::createSwapchainKHR(engine.device, &createInfo)!;
    engine.swap_chain_images = vk::getSwapchainImagesKHR(engine.device, engine.swap_chain)!;
    uint n = engine.swap_chain_images.len;
    vk::ImageView* buffer = (vk::ImageView*) malloc(n * vk::ImageView.sizeof);
    engine.swap_chain_image_views = buffer[:n];
    for (uint i = 0; i < n; i++) {
        engine.swap_chain_image_views[i] = createImageView(engine.swap_chain_images[i], engine.swap_chain_format.format)!;
    }
}

fn void Engine.destroySwapchain(Engine* engine) {
    foreach (view : engine.swap_chain_image_views) {
        vk::destroyImageView(engine.device, view);
    }
    vk::destroySwapchainKHR(engine.device, engine.swap_chain);
    free(engine.swap_chain_image_views);
    free(engine.swap_chain_images);
}

fn void! Engine.recreateSwapchain(Engine* engine) {
    vk::deviceWaitIdle(engine.device)!;
    destroySwapchain(engine);
    createSwapchain(engine)!;
}

fn void! Engine.createCommandPool(Engine* engine) {
    QueueFamilyIndices queueFamilyIndices = findQueueFamilies(engine.physical_device)!;
    vk::CommandPoolCreateInfo info = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .flags = { .reset_command_buffer },
        .queue_family_index = queueFamilyIndices.graphics_family,
    };
    engine.command_pool = vk::createCommandPool(engine.device, &info)!;
}

fn void Engine.destroyCommandPool(Engine* engine) {
    vk::destroyCommandPool(engine.device, engine.command_pool);
}

fn vk::CommandBuffer! Engine.beginSingleTimeCommand(Engine* engine) {
    vk::CommandBuffer[] command_buffer = vk::allocateCommandBuffers(engine.device, &&vk::CommandBufferAllocateInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_pool = engine.command_pool,
        .command_buffer_count = 1,
    })!;
    vk::beginCommandBuffer(command_buffer[0], &&vk::CommandBufferBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
        .flags = { .one_time_submit },
    })!;
    return command_buffer[0];
}

fn void! Engine.endSingleTimeCommand(Engine* engine, vk::CommandBuffer command_buffer) {
    defer vk::freeCommandBuffers(engine.device, engine.command_pool, 1, &command_buffer);
    vk::endCommandBuffer(command_buffer)!;
    vk::queueSubmit(engine.graphics_queue, 1, &&vk::SubmitInfo {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .command_buffer_count = 1,
        .p_command_buffers = &command_buffer,
    }, (vk::Fence)0)!;
    vk::queueWaitIdle(engine.graphics_queue)!;
}
