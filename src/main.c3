module std::core::env;
const bool GLFW_INCLUDE_VULKAN = true;
module hellovk;
import std::core::mem;
import std::io;
import std::time;
import std::math;
import std::math::matrix;
import std::math::vector;
import glfw;
import stbimage;
import vk;

const WIDTH = 1024;
const HEIGHT = 768;
const TITLE = "Hello Vulkan!";
const ENGINE_NAME = "Soreal Engine";
const ZString[*] REQUIRED_EXTENSIONS = {
    vk::KHR_SWAPCHAIN_EXTENSION_NAME,
    vk::KHR_DYNAMIC_RENDERING_EXTENSION_NAME,
};
const ENABLE_VALIDATION_LAYERS = false;
const ZString[*] VALIDATION_LAYERS @if(ENABLE_VALIDATION_LAYERS) = {
    "VK_LAYER_KHRONOS_validation",
};
const char[*] VERTEX_CODE = $embed("shaders/vert.spv");
const char[*] FRAGMENT_CODE = $embed("shaders/frag.spv");

const MAX_FRAMES_IN_FLIGHT = 2;
const Vertex[*] VERTICES = {
    // Front face
    {.position = {-1.0, -1.0, 1.0, 1.0}, .color = {0.25, 0.25, 0.5, 1.0}, .normal = {0.0, 0.0, 1.0, 1.0}, .uv = {0.0, 1.0}},
    {.position = {1.0, -1.0, 1.0, 1.0}, .color = {0.5, 0.5, 0.0, 1.0}, .normal = {0.0, 0.0, 1.0, 1.0}, .uv = {1.0, 1.0}},
    {.position = {1.0, 1.0, 1.0, 1.0}, .color = {0.0, 0.5, 0.5, 1.0}, .normal = {0.0, 0.0, 1.0, 1.0}, .uv = {1.0, 0.0}},
    {.position = {-1.0, 1.0, 1.0, 1.0}, .color = {0.5, 1.0, 0.5, 1.0}, .normal = {0.0, 0.0, 1.0, 1.0}, .uv = {0.0, 0.0}},

    // Back face
    {.position = {-1.0, 1.0, -1.0, 1.0}, .color = {1.0, 0.5, 0.0, 1.0}, .normal = {0.0, 0.0, -1.0, 1.0}, .uv = {1.0, 1.0}},
    {.position = {1.0, 1.0, -1.0, 1.0}, .color = {0.5, 0.5, 0.5, 1.0}, .normal = {0.0, 0.0, -1.0, 1.0}, .uv = {0.0, 1.0}},
    {.position = {1.0, -1.0, -1.0, 1.0}, .color = {0.5, 0.5, 0.5, 1.0}, .normal = {0.0, 0.0, -1.0, 1.0}, .uv = {0.0, 0.0}},
    {.position = {-1.0, -1.0, -1.0, 1.0}, .color = {0.25, 0.25, 1.0, 1.0}, .normal = {0.0, 0.0, -1.0, 1.0}, .uv = {1.0, 0.0}},

    // Top face
    {.position = {1.0, 1.0, -1.0, 1.0}, .color = {1.0, 0.5, 0.0, 1.0}, .normal = {0.0, 1.0, 0.0, 1.0}, .uv = {0.0, 1.0}},
    {.position = {-1.0, 1.0, -1.0, 1.0}, .color = {0.5, 0.5, 0.5, 1.0}, .normal = {0.0, 1.0, 0.0, 1.0}, .uv = {1.0, 1.0}},
    {.position = {-1.0, 1.0, 1.0, 1.0}, .color = {0.5, 0.5, 0.0, 1.0}, .normal = {0.0, 1.0, 0.0, 1.0}, .uv = {1.0, 0.0}},
    {.position = {1.0, 1.0, 1.0, 1.0}, .color = {0.25, 0.25, 0.5, 1.0}, .normal = {0.0, 1.0, 0.0, 1.0}, .uv = {0.0, 0.0}},

    // Bottom face
    {.position = {1.0, -1.0, 1.0, 1.0}, .color = {0.5, 1.0, 0.5, 1.0}, .normal = {0.0, -1.0, 0.0, 1.0}, .uv = {0.0, 1.0}},
    {.position = {-1.0, -1.0, 1.0, 1.0}, .color = {0.0, 0.5, 0.5, 1.0}, .normal = {0.0, -1.0, 0.0, 1.0}, .uv = {1.0, 1.0}},
    {.position = {-1.0, -1.0, -1.0, 1.0}, .color = {0.5, 0.5, 0.5, 1.0}, .normal = {0.0, -1.0, 0.0, 1.0}, .uv = {1.0, 0.0}},
    {.position = {1.0, -1.0, -1.0, 1.0}, .color = {0.25, 0.25, 1.0, 1.0}, .normal = {0.0, -1.0, 0.0, 1.0}, .uv = {0.0, 0.0}},

    // Right face
    {.position = {1.0, -1.0, -1.0, 1.0}, .color = {0.5, 0.5, 0.0, 1.0}, .normal = {1.0, 0.0, 0.0, 1.0}, .uv = {0.0, 1.0}},
    {.position = {1.0, 1.0, -1.0, 1.0}, .color = {0.5, 0.5, 0.5, 1.0}, .normal = {1.0, 0.0, 0.0, 1.0}, .uv = {1.0, 1.0}},
    {.position = {1.0, 1.0, 1.0, 1.0}, .color = {0.5, 0.5, 0.5, 1.0}, .normal = {1.0, 0.0, 0.0, 1.0}, .uv = {1.0, 0.0}},
    {.position = {1.0, -1.0, 1.0, 1.0}, .color = {0.0, 0.5, 0.5, 1.0}, .normal = {1.0, 0.0, 0.0, 1.0}, .uv = {0.0, 0.0}},

    // Left face
    {.position = {-1.0, -1.0, 1.0, 1.0}, .color = {1.0, 0.5, 0.0, 1.0}, .normal = {-1.0, 0.0, 0.0, 1.0}, .uv = {0.0, 1.0}},
    {.position = {-1.0, 1.0, 1.0, 1.0}, .color = {0.25, 0.25, 0.5, 1.0}, .normal = {-1.0, 0.0, 0.0, 1.0}, .uv = {1.0, 1.0}},
    {.position = {-1.0, 1.0, -1.0, 1.0}, .color = {0.5, 1.0, 0.5, 1.0}, .normal = {-1.0, 0.0, 0.0, 1.0}, .uv = {1.0, 0.0}},
    {.position = {-1.0, -1.0, -1.0, 1.0}, .color = {0.25, 0.25, 1.0, 1.0}, .normal = {-1.0, 0.0, 0.0, 1.0}, .uv = {0.0, 0.0}},
};

const ushort[*] INDICES = {
    // Front face
    0, 1, 2, 2, 3, 0,
    // Back face
    4, 5, 6, 6, 7, 4,
    // Top face
    8, 9, 10, 10, 11, 8,
    // Bottom face
    12, 13, 14, 14, 15, 12,
    // Right face
    16, 17, 18, 18, 19, 16,
    // Left face
    20, 21, 22, 22, 23, 20
};


glfw::Window* g_window;
vk::Instance g_instance;
vk::SurfaceKHR g_surface;
vk::DebugUtilsMessengerEXT g_debug_messenger @if(ENABLE_VALIDATION_LAYERS);

vk::PhysicalDevice g_physical_device;
vk::Device g_device;
vk::Queue g_graphics_queue;
vk::Queue g_present_queue;

vk::SurfaceFormatKHR g_swap_chain_format;
vk::Extent2D g_swap_chain_extent;
vk::SwapchainKHR g_swap_chain;
vk::Image[] g_swap_chain_images;
vk::ImageView[] g_swap_chain_image_views;

vk::DescriptorSetLayout g_descriptor_set_layout;
vk::PipelineLayout g_pipeline_layout;
vk::Pipeline g_graphics_pipeline;
vk::DescriptorPool g_descriptor_pool;
vk::DescriptorSet[MAX_FRAMES_IN_FLIGHT] g_descriptor_sets;

vk::CommandPool g_command_pool;
vk::CommandBuffer[MAX_FRAMES_IN_FLIGHT] g_command_buffers;
vk::Semaphore[MAX_FRAMES_IN_FLIGHT] g_image_available_semaphore;
vk::Semaphore[MAX_FRAMES_IN_FLIGHT] g_render_finished_semaphore;
vk::Fence[MAX_FRAMES_IN_FLIGHT] g_in_flight_fences;

vk::Buffer[MAX_FRAMES_IN_FLIGHT] g_uniform_buffers;
vk::DeviceMemory[MAX_FRAMES_IN_FLIGHT] g_uniform_memory;
void*[MAX_FRAMES_IN_FLIGHT] g_uniform_buffer_mapped;
vk::Buffer g_index_buffer;
vk::DeviceMemory g_index_memory;
vk::Buffer g_vertex_buffer;
vk::DeviceMemory g_vertex_memory;
vk::Sampler g_sampler;
vk::Image g_texture_image;
vk::ImageView g_texture_image_view;
vk::DeviceMemory g_texture_image_memory;

time::Time g_last_frame_timestamp;
time::Time g_start_timestamp;
UniformBuffer g_ubo;

uint g_current_frame;

fn int main(String[] args) {
    io::printfn("GLFW %s",glfw::getVersionString());
    glfw::setErrorCallback(fn void(int error, ZString description) => io::printfn("GLFW error: %s", description));
    if (!glfw::init()) {
        return -1;
    }
    defer glfw::terminate();
    glfw::windowHint(glfw::CLIENT_API, glfw::NO_API);
    g_window = glfw::createWindow(WIDTH, HEIGHT, TITLE, null, null);
    if (g_window == null) {
        return -1;
    }
    io::printfn("Window created %x", g_window);
    defer glfw::destroyWindow(g_window);
    init()!!;
    defer destroy();
    while (!glfw::windowShouldClose(g_window)) {
        glfw::pollEvents();
        update();
        fault excuse = @catch(render());
        if (excuse) {
            io::printfn("Error: while rendering");
        };
    }
    return 0;
}

fn void? createVulkanInstance() {
    vk::loadProcAddressesGlobal(&glfw::getInstanceProcAddress);
    ulong extensionCount;
    ZString* glfwExtensions = glfw::getRequiredInstanceExtensions(&extensionCount);
    ZString* extensions = (ZString*)malloc(extensionCount * ZString.sizeof);
    mem::copy(extensions, glfwExtensions, extensionCount * ZString.sizeof);
    defer free(extensions);
    vk::ApplicationInfo app_info = {
        .s_type = vk::STRUCTURE_TYPE_APPLICATION_INFO,
        .p_application_name = TITLE,
        .application_version = vk::@make_version(1, 0, 0),
        .p_engine_name = ENGINE_NAME,
        .engine_version = vk::@make_version(1, 0, 0),
        .api_version = vk::API_VERSION_1_3,
    };
    vk::InstanceCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .p_application_info = &app_info,
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
            .message_severity = { .error, .warning, .info },
            .message_type = { .general, .validation, .performance, .device_address_binding },
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
    g_instance = vk::createInstance(&createInfo)!;
    vk::loadProcAddressesInstance(g_instance);
    $if ENABLE_VALIDATION_LAYERS:
        g_debug_messenger = vk::createDebugUtilsMessengerEXT(
            g_instance,
            &debugCreateInfo,
        )!;
    $endif
}

fn void destroyVulkanInstance() {
    $if ENABLE_VALIDATION_LAYERS:
        vk::destroyDebugUtilsMessengerEXT(g_instance, g_debug_messenger);
    $endif
    vk::destroyInstance(g_instance);
}

fn void? createWindowSurface() {
    vk::check(glfw::createWindowSurface(g_instance, g_window, null, &g_surface))!;
}

fn void destroySurface() {
    vk::destroySurfaceKHR(g_instance, g_surface);
}

fn uint scorePhysicalDevice(vk::PhysicalDevice device) {
    uint score = 0;
    vk::PhysicalDeviceProperties properties = vk::getPhysicalDeviceProperties(device);
    vk::PhysicalDeviceFeatures features = vk::getPhysicalDeviceFeatures(device);
    ZString deviceName = (ZString)properties.device_name[0..];
    io::printfn("Scoring device %s", deviceName);
    defer io::printfn("Device %s scored %d", deviceName, score);
    $if !env::DARWIN:
        if (!features.geometry_shader) {
            return 0;
        }
    $endif
    {
        vk::ExtensionProperties[]? extensions = vk::enumerateDeviceExtensionProperties(device, null);
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
                if (name.len() == required.len() && mem::equals(name,required, name.len())) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                io::printfn("Extension %s not found in %s", required, deviceName);
                return 0;
            }
        }
    }
    {
        SwapchainSupportDetails? support = querySwapchainSupport(device);
        if (catch excuse = support) {
            io::printfn("Cound not get swapchain support for %s", deviceName);
            return 0;
        }
        support.free();
    }
    {
        QueueFamilyIndices? indices = findQueueFamilies(device);
        if (catch excuse = indices) {
            io::printfn("Cound not get queue families for %s", deviceName);
            return 0;
        }
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

fn void? pickPhysicalDevice() {
    vk::PhysicalDevice[] devices = vk::enumeratePhysicalDevices(g_instance)!;
    defer free(devices);
    g_physical_device = devices[0];
    uint bestScore = 0;
    foreach (device: devices) {
        int score = scorePhysicalDevice(device);
        io::printfn("Device %x score: %d", device, score);
        if (score > bestScore) {
            g_physical_device = device;
            bestScore = score;
        }
    }
    io::printfn("Selected physical device: %x with score %d", g_physical_device, bestScore);
}

fn void destroyDevice() {
    vk::destroyDevice(g_device, null);
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

fn SwapchainSupportDetails? querySwapchainSupport(vk::PhysicalDevice device) {
    SwapchainSupportDetails ret;
    ret.capabilities = vk::getPhysicalDeviceSurfaceCapabilitiesKHR(device, g_surface)!;
    ret.formats = vk::getPhysicalDeviceSurfaceFormatsKHR(device, g_surface)!;
    ret.present_modes = vk::getPhysicalDeviceSurfacePresentModesKHR(device, g_surface)!;
    return ret;
}

struct QueueFamilyIndices {
    uint graphics_family;
    uint present_family;
}

fn QueueFamilyIndices? findQueueFamilies(vk::PhysicalDevice device) {
    vk::QueueFamilyProperties[] queueFamilies = vk::getPhysicalDeviceQueueFamilyProperties(device);
    QueueFamilyIndices indices;
    bool foundGraphics = false;
    bool foundPresent = false;
    for (uint i = 0; i < queueFamilies.len; i++) {
        if (queueFamilies[i].queue_flags.graphics) {
            indices.graphics_family = i;
            foundGraphics = true;
            io::printfn("Queue family %d support graphics", i);
        }
        uint supported = glfw::getPhysicalDevicePresentationSupport(g_instance, device, i);
        //vk::check(vk::getPhysicalDeviceSurfaceSupportKHR(device, i, g_surface, &supported))!;
        if (supported) {
            indices.present_family = i;
            foundPresent = true;
            io::printfn("Queue family %d support present", i);
        }
        if (foundGraphics && foundPresent) {
            return indices;
        }
    }
    return vk::error::ERROR_UNKNOWN?;
}

fn void? createLogicalDevice() {
    QueueFamilyIndices indices = findQueueFamilies(g_physical_device)!;
    ZString[] layers;
    $if ENABLE_VALIDATION_LAYERS:
        layers = ZString[*] {
          "VK_LAYER_KHRONOS_validation"
        };
    $endif
    vk::DeviceQueueCreateInfo queueCreateInfo = {
        .s_type = vk::STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
        .queue_family_index = indices.graphics_family,
        .queue_count = 1,
        .p_queue_priorities = &&1.0f,
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
    g_device = vk::createDevice(g_physical_device, &createInfo)!;
    g_graphics_queue = vk::getDeviceQueue(g_device, indices.graphics_family, 0);
    g_present_queue = vk::getDeviceQueue(g_device, indices.present_family, 0);
}

fn vk::SurfaceFormatKHR pickSwapSurfaceFormat(vk::SurfaceFormatKHR[] formats) {
    foreach (f: formats) {
        if (f.format == vk::FORMAT_B8G8R8A8_SRGB && f.color_space == vk::COLOR_SPACE_SRGB_NONLINEAR_KHR) {
            return f;
        }
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

fn void? createSwapchain() {
    QueueFamilyIndices indices = findQueueFamilies(g_physical_device)!;
    SwapchainSupportDetails swapChainSupport = querySwapchainSupport(g_physical_device)!;
    vk::PresentModeKHR presentMode = pickSwapPresentMode(swapChainSupport.present_modes);
    g_swap_chain_format = pickSwapSurfaceFormat(swapChainSupport.formats);
    g_swap_chain_extent = pickSwapExtent(swapChainSupport.capabilities);
    uint count = swapChainSupport.capabilities.min_image_count + 1;
    bool unlimited = swapChainSupport.capabilities.max_image_count == 0;
    if (!unlimited && count > swapChainSupport.capabilities.max_image_count) {
        count = swapChainSupport.capabilities.max_image_count;
    }
    uint[2] indiceArray = {indices.graphics_family, indices.present_family};
    vk::SwapchainCreateInfoKHR createInfo = {
        .s_type = vk::STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
        .surface = g_surface,
        .min_image_count = count,
        .image_format = g_swap_chain_format.format,
        .image_color_space = g_swap_chain_format.color_space,
        .image_extent = g_swap_chain_extent,
        .image_array_layers = 1,
        .image_usage = { .color_attachment },
        .image_sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
        .queue_family_index_count = 2,
        .p_queue_family_indices = &indiceArray,
        .pre_transform = swapChainSupport.capabilities.current_transform,
        .composite_alpha = { .opaque },
        .present_mode = presentMode,
        .clipped = (uint)true,
    };
    if (indices.graphics_family != indices.present_family) {
        createInfo.image_sharing_mode = vk::SHARING_MODE_CONCURRENT;
        createInfo.queue_family_index_count = indiceArray.len;
        createInfo.p_queue_family_indices = &indiceArray;
    }
    g_swap_chain = vk::createSwapchainKHR(g_device, &createInfo)!;
    g_swap_chain_images = vk::getSwapchainImagesKHR(g_device, g_swap_chain)!;
    vk::ImageView* buffer = (vk::ImageView*)malloc(g_swap_chain_images.len * vk::ImageView.sizeof);
    g_swap_chain_image_views = buffer[:g_swap_chain_images.len];
    for (uint i = 0; i < g_swap_chain_images.len; i++) {
        g_swap_chain_image_views[i] = createImageView(g_swap_chain_images[i], g_swap_chain_format.format)!;
    }
}

fn void destroySwapchain() {
    foreach (view:g_swap_chain_image_views) {
        vk::destroyImageView(g_device, view);
    }
    vk::destroySwapchainKHR(g_device, g_swap_chain);
    free(g_swap_chain_image_views);
    free(g_swap_chain_images);
}

fn vk::ShaderModule? createShaderModule(char[] code) {
    vk::ShaderModuleCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
        .code_size = code.len,
        .p_code = (uint*)code.ptr,
    };
    return vk::createShaderModule(g_device, &createInfo)!;
}

fn void? createDescriptorSetLayout() {
    vk::DescriptorSetLayoutBinding ubo_binding = {
        .binding = 0,
        .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
        .descriptor_count = 1,
        .stage_flags = {.vertex},
    };
    vk::DescriptorSetLayoutBinding sampler_binding = {
        .binding = 1,
        .descriptor_type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptor_count = 1,
        .stage_flags = {.fragment},
    };
    vk::DescriptorSetLayoutBinding[*] bindings = {
        ubo_binding, sampler_binding
    };
    vk::DescriptorSetLayoutCreateInfo info = {
        .s_type        = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
		.binding_count = bindings.len,
		.p_bindings    = &bindings,
	};
	g_descriptor_set_layout = vk::createDescriptorSetLayout(g_device, &info)!;
}

fn void destroyDescriptorSetLayout() {
    vk::destroyDescriptorSetLayout(g_device, g_descriptor_set_layout);
}

fn void? createGraphicsPipeline() {
    vk::ShaderModule v = createShaderModule(&VERTEX_CODE)!;
    defer vk::destroyShaderModule(g_device, v);
    vk::ShaderModule f = createShaderModule(&FRAGMENT_CODE)!;
    defer vk::destroyShaderModule(g_device, f);
    vk::PipelineShaderStageCreateInfo[*] shader_stages = {{
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = { .vertex },
        .module_ = v,
        .p_name = "main",
    }, {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = { .fragment },
        .module_ = f,
        .p_name = "main",
    }};
    vk::DynamicState[*] dynamicStates = {
        vk::DYNAMIC_STATE_VIEWPORT,
        vk::DYNAMIC_STATE_SCISSOR
    };
    vk::PipelineDynamicStateCreateInfo dynamicState = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO,
        .dynamic_state_count = dynamicStates.len,
        .p_dynamic_states = &dynamicStates,
    };
    vk::VertexInputBindingDescription v_binding_description = {
		.binding   = 0,
		.stride    = Vertex.sizeof,
		.input_rate = vk::VERTEX_INPUT_RATE_VERTEX,
	};
	vk::VertexInputAttributeDescription[*] v_pos_attribute_description = {{
	   .binding = 0, .location = 0, .format = vk::FORMAT_R32G32B32A32_SFLOAT, .offset = Vertex.position.offsetof
	}, {
	   .binding = 0, .location = 1, .format = vk::FORMAT_R32G32B32A32_SFLOAT, .offset = Vertex.color.offsetof
	}, {
	   .binding = 0, .location = 2, .format = vk::FORMAT_R32G32B32A32_SFLOAT, .offset = Vertex.normal.offsetof
	}, {
	   .binding = 0, .location = 3, .format = vk::FORMAT_R32G32_SFLOAT, .offset = Vertex.uv.offsetof
	}};
    vk::PipelineVertexInputStateCreateInfo vertexInputInfo = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
        .vertex_binding_description_count   = 1,
    	.p_vertex_binding_descriptions      = &v_binding_description,
    	.vertex_attribute_description_count = v_pos_attribute_description.len,
    	.p_vertex_attribute_descriptions    = &v_pos_attribute_description,
    };
    vk::PipelineInputAssemblyStateCreateInfo inputAssembly = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
        .topology = vk::PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
    };
    vk::PipelineViewportStateCreateInfo viewportState = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO,
        .viewport_count = 1,
        .scissor_count = 1,
    };
    vk::PipelineRasterizationStateCreateInfo rasterizer = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
        .polygon_mode = vk::POLYGON_MODE_FILL,
        .cull_mode = { .back },
        .front_face = vk::FRONT_FACE_CLOCKWISE,
        .line_width = 1.0,
    };
    vk::PipelineMultisampleStateCreateInfo multisampling = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
        .rasterization_samples = { .n_1 },
        .min_sample_shading = 1.0,
    };
    vk::PipelineColorBlendAttachmentState colorBlendAttachment = {
        .color_write_mask = { .r, .g, .b, .a },
    };
    vk::PipelineColorBlendStateCreateInfo colorBlending = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
        .attachment_count = 1,
        .p_attachments = &colorBlendAttachment,
    };
    vk::PipelineLayoutCreateInfo create_info = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
        .set_layout_count = 1,
        .p_set_layouts = &g_descriptor_set_layout,
    };
    g_pipeline_layout = vk::createPipelineLayout(
        g_device,
        &create_info)!;
    vk::PipelineRenderingCreateInfoKHR dynamic_rendering_info = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_RENDERING_CREATE_INFO_KHR,
        .color_attachment_count = 1,
        .p_color_attachment_formats = &g_swap_chain_format.format,
    };
    vk::GraphicsPipelineCreateInfo pipelineInfo = {
        .s_type = vk::STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,
        .stage_count = shader_stages.len,
        .p_stages = &shader_stages,
        .p_vertex_input_state = &vertexInputInfo,
        .p_input_assembly_state = &inputAssembly,
        .p_viewport_state = &viewportState,
        .p_rasterization_state = &rasterizer,
        .p_multisample_state = &multisampling,
        .p_color_blend_state = &colorBlending,
        .p_dynamic_state = &dynamicState,
        .layout = g_pipeline_layout,
        .base_pipeline_index = -1,
        .p_next = &dynamic_rendering_info,
    };
    g_graphics_pipeline = vk::createGraphicsPipelines(g_device, (vk::PipelineCache)0, 1, &pipelineInfo)!;
}

fn void destroyGraphicsPipeline() {
    vk::destroyPipeline(g_device, g_graphics_pipeline);
    vk::destroyPipelineLayout(g_device, g_pipeline_layout);
}

fn void? createCommandPool() {
    QueueFamilyIndices queueFamilyIndices = findQueueFamilies(g_physical_device)!;
    vk::CommandPoolCreateInfo poolInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .flags = { .reset_command_buffer },
        .queue_family_index = queueFamilyIndices.graphics_family,
    };
    g_command_pool = vk::createCommandPool(g_device, &poolInfo)!;
    vk::CommandBufferAllocateInfo allocInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .command_pool = g_command_pool,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_buffer_count = g_command_buffers.len,
    };
    vk::allocateCommandBuffers(g_device, &allocInfo, &g_command_buffers)!;
}

fn void destroyCommandPool() {
    vk::freeCommandBuffers(g_device, g_command_pool, g_command_buffers.len, &g_command_buffers);
    vk::destroyCommandPool(g_device, g_command_pool, null);
}

fn void? createSemaphores() {
    vk::SemaphoreCreateInfo semaphoreInfo = {
        .s_type = vk::STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
    };
    vk::FenceCreateInfo fenceInfo = {
        .s_type = vk::STRUCTURE_TYPE_FENCE_CREATE_INFO,
        .flags = { .signaled },
    };
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        g_image_available_semaphore[i] = vk::createSemaphore(g_device, &semaphoreInfo)!;
        g_render_finished_semaphore[i] = vk::createSemaphore(g_device, &semaphoreInfo)!;
        g_in_flight_fences[i] = vk::createFence(g_device, &fenceInfo)!;
    }
}

fn void destroySemaphores() {
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::destroySemaphore(g_device, g_image_available_semaphore[i], null);
        vk::destroySemaphore(g_device, g_render_finished_semaphore[i], null);
        vk::destroyFence(g_device, g_in_flight_fences[i], null);
    }
}

fn uint? findMemoryType(uint filter, vk::MemoryPropertyFlags flags) {
    vk::PhysicalDeviceMemoryProperties props = vk::getPhysicalDeviceMemoryProperties(g_physical_device);
    for (uint i = 0; i < props.memory_type_count; i++) {
        if (filter & (1 << i) == 0) {
            continue;
        }
        if ((props.memory_types[i].property_flags & flags) != flags) {
            continue;
        }
        return i;
    }
    return vk::error::ERROR_UNKNOWN?;
}
fn void? createBuffer(vk::DeviceSize size, vk::BufferUsageFlags usage, vk::MemoryPropertyFlags properties, vk::Buffer* buffer, vk::DeviceMemory* memory) {
    vk::BufferCreateInfo bufferInfo = {
        .s_type = vk::STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .size = size,
        .usage = usage,
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
    };
    *buffer = vk::createBuffer(g_device, &bufferInfo)!;
    vk::MemoryRequirements requirements = vk::getBufferMemoryRequirements(g_device, *buffer);
    vk::MemoryAllocateInfo allocInfo = {
        .s_type = vk::STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        .allocation_size = requirements.size,
        .memory_type_index = findMemoryType(requirements.memory_type_bits, properties)!,
    };
    *memory = vk::allocateMemory(g_device, &allocInfo)!;
    vk::bindBufferMemory(g_device, *buffer, *memory, 0)!;
}

fn vk::CommandBuffer? beginSingleTimeCommand() {
    vk::CommandBuffer command_buffer;
    vk::CommandBufferAllocateInfo alloc_info = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_pool = g_command_pool,
        .command_buffer_count = 1,
    };
    vk::allocateCommandBuffers(g_device, &alloc_info, &command_buffer)!;
    vk::CommandBufferBeginInfo begin_info = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
        .flags = { .one_time_submit },
    };
    vk::beginCommandBuffer(command_buffer, &begin_info)!;
    return command_buffer;
}

fn void? endSingleTimeCommand(vk::CommandBuffer command_buffer) {
    defer vk::freeCommandBuffers(g_device, g_command_pool, 1, &command_buffer);
    vk::endCommandBuffer(command_buffer)!;
    vk::SubmitInfo submit_info = {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .command_buffer_count = 1,
        .p_command_buffers = &command_buffer,
    };
    vk::queueSubmit(g_graphics_queue, 1, &submit_info, (vk::Fence)0)!;
    vk::queueWaitIdle(g_graphics_queue)!;
}

fn void? copyBuffer(vk::Buffer dst, vk::Buffer src, vk::DeviceSize size) {
    vk::CommandBuffer command_buffer = beginSingleTimeCommand()!;
    vk::BufferCopy copy_region = {
        .size =size,
    };
    vk::cmdCopyBuffer(command_buffer, src, dst, 1, &copy_region);
    endSingleTimeCommand(command_buffer)!;
}

fn void? createBufferInit(void* data, vk::DeviceSize size, vk::BufferUsageFlags usage, vk::MemoryPropertyFlags flags, vk::Buffer* buffer, vk::DeviceMemory* memory) {
    vk::Buffer stg_buffer;
    vk::DeviceMemory stg_memory;
    createBuffer(size, { .transfer_src }, { .host_visible, .host_coherent }, &stg_buffer, &stg_memory)!;
    defer {
        vk::destroyBuffer(g_device, stg_buffer, null);
        vk::freeMemory(g_device, stg_memory, null);
    }
    void* mapped = vk::mapMemory(g_device, stg_memory, 0, size)!;
    defer vk::unmapMemory(g_device, stg_memory);
    mem::copy(mapped, data, (usz)size);
    vk::BufferUsageFlags usage_flags = { .transfer_dst };
    createBuffer(size, usage_flags | usage, flags, buffer, memory)!;
    copyBuffer(*buffer, stg_buffer, size)!;
}

fn void? createBuffers() {
    createBufferInit(&VERTICES, (vk::DeviceSize)($sizeof(VERTICES)), { .vertex_buffer }, { .device_local }, &g_vertex_buffer, &g_vertex_memory)!;
    createBufferInit(&INDICES, (vk::DeviceSize)($sizeof(INDICES)), { .index_buffer }, { .device_local }, &g_index_buffer, &g_index_memory)!;
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        createBufferInit(&g_ubo, UniformBuffer.sizeof, { .uniform_buffer }, { .host_visible, .host_coherent }, &g_uniform_buffers[i], &g_uniform_memory[i])!;
        g_uniform_buffer_mapped[i] = vk::mapMemory(g_device, g_uniform_memory[i], 0, UniformBuffer.sizeof)!;
    }
    createTextures()!;
}

fn void destroyBuffers() {
    vk::destroyBuffer(g_device, g_vertex_buffer, null);
    vk::freeMemory(g_device, g_vertex_memory, null);
    vk::destroyBuffer(g_device, g_index_buffer, null);
    vk::freeMemory(g_device, g_index_memory, null);
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::destroyBuffer(g_device, g_uniform_buffers[i], null);
        vk::freeMemory(g_device, g_uniform_memory[i], null);
    }
    destroyTextures();
}

fn void? createTextures() {
    int w, h, channel;
    const char[*] DATA = $embed("assets/statue-1275469_1280.jpg");
    char* pixels = stbimage::load_from_memory(&DATA, DATA.len, &w, &h, &channel, stbimage::RGB_ALPHA);
    // defer stbimage::image_free(pixels);
    vk::DeviceSize size = (vk::DeviceSize)(w * h * 4);
    vk::Buffer stg_buffer;
    vk::DeviceMemory stg_memory;
    createBuffer(size, { .transfer_src }, { .host_visible, .host_coherent }, &stg_buffer, &stg_memory)!;
    defer vk::freeMemory(g_device, stg_memory, null);
    defer vk::destroyBuffer(g_device, stg_buffer, null);
    void* image_data_mapped = vk::mapMemory(g_device, stg_memory, 0, size)!;
    mem::copy(image_data_mapped, pixels, (usz)size);
    vk::unmapMemory(g_device, stg_memory);
    vk::ImageCreateInfo create_info = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_CREATE_INFO,
        .image_type = vk::IMAGE_TYPE_2D,
        .extent = {
            .width = w,
            .height = h,
            .depth = 1
        },
        .mip_levels = 1,
        .array_layers = 1,
        .format = vk::FORMAT_R8G8B8A8_SRGB,
        .tiling = vk::IMAGE_TILING_OPTIMAL,
        .usage = { .transfer_dst, .sampled },
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
        .initial_layout = vk::IMAGE_LAYOUT_UNDEFINED,
        .samples = { .n_1 },
    };
    g_texture_image = vk::createImage(g_device, &create_info)!;
    vk::MemoryRequirements requirements = vk::getImageMemoryRequirements(g_device, g_texture_image);
    vk::MemoryAllocateInfo allocate_info = {
        .allocation_size = requirements.size,
        .memory_type_index = findMemoryType(requirements.memory_type_bits, { .device_local })!,
    };
    g_texture_image_memory = vk::allocateMemory(g_device, &allocate_info)!;
    vk::bindImageMemory(g_device, g_texture_image, g_texture_image_memory, 0)!;
    transitionImageLayout(g_texture_image, vk::FORMAT_R8G8B8A8_SRGB, vk::IMAGE_LAYOUT_UNDEFINED, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL)!;
    copyBufferImage(stg_buffer, g_texture_image, (uint)w, (uint)h)!;
    transitionImageLayout(g_texture_image, vk::FORMAT_R8G8B8A8_SRGB, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL)!;
    g_texture_image_view = createImageView(g_texture_image, vk::FORMAT_R8G8B8A8_SRGB)!;
    vk::SamplerCreateInfo sampler_info = {
        .s_type = vk::STRUCTURE_TYPE_SAMPLER_CREATE_INFO,
        .mag_filter = vk::FILTER_LINEAR,
        .min_filter = vk::FILTER_LINEAR,
        .address_mode_u = vk::SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
        .address_mode_v = vk::SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
        .address_mode_w = vk::SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE,
        .anisotropy_enable = vk::TRUE,
        .max_anisotropy = 1.0f,
        .border_color = vk::BORDER_COLOR_INT_OPAQUE_WHITE,
        .unnormalized_coordinates = vk::FALSE,
        .compare_enable = vk::FALSE,
        .compare_op = vk::COMPARE_OP_ALWAYS,
        .mipmap_mode = vk::SAMPLER_MIPMAP_MODE_LINEAR,
    };
    g_sampler = vk::createSampler(g_device, &sampler_info)!;
}

fn void? transitionImageLayout(vk::Image image, vk::Format format, vk::ImageLayout oldLayout, vk::ImageLayout newLayout) {
    vk::CommandBuffer command_buffer = beginSingleTimeCommand()!;
    vk::PipelineStageFlags src_stage;
    vk::PipelineStageFlags dst_stage;
    vk::ImageMemoryBarrier barrier = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .old_layout = oldLayout,
        .new_layout = newLayout,
        .src_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .image = image,
        .subresource_range = {
            .aspect_mask = { .color },
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1,
        },
    };
    if(oldLayout == vk::IMAGE_LAYOUT_UNDEFINED && newLayout == vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL) {
        barrier.dst_access_mask = { .transfer_write };
        src_stage = { .top_of_pipe };
        dst_stage = { .transfer };
    } else if(oldLayout == vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL && newLayout == vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL) {
        barrier.src_access_mask = { .transfer_write };
        barrier.dst_access_mask = { .shader_read };
        src_stage = { .transfer };
        dst_stage = { .fragment_shader };
    }
    vk::cmdPipelineBarrier(
        command_buffer,
        src_stage, dst_stage,
        {},
        0, null,
        0, null,
        1, &barrier);
    endSingleTimeCommand(command_buffer)!;
}

fn void? copyBufferImage(vk::Buffer buffer, vk::Image image, uint width, uint height) {
    vk::CommandBuffer command_buffer = beginSingleTimeCommand()!;
    vk::BufferImageCopy copy_region = {
        .buffer_offset = 0,
        .buffer_row_length = 0,
        .buffer_image_height = 0,
        .image_subresource = {
            .aspect_mask = { .color },
            .mip_level = 0,
            .base_array_layer = 0,
            .layer_count = 1,
        },
        .image_offset = {0, 0, 0},
        .image_extent = {width, height, 1},
    };
    vk::cmdCopyBufferToImage(command_buffer, buffer, image, vk::IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &copy_region);
    endSingleTimeCommand(command_buffer)!;
}

fn vk::ImageView? createImageView(vk::Image image, vk::Format format) {
    vk::ImageViewCreateInfo info = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
        .image = image,
        .view_type = vk::IMAGE_VIEW_TYPE_2D,
        .format = format,
        .subresource_range = {
            .aspect_mask = { .color },
            .level_count = 1,
            .layer_count = 1,
        },
    };
    return vk::createImageView(g_device, &info)!;
}

fn void destroyTextures() {
    vk::destroyImage(g_device, g_texture_image, null);
    vk::destroyImageView(g_device, g_texture_image_view, null);
    vk::destroySampler(g_device, g_sampler, null);
}

fn void createUBO() {
    int width, height;
    glfw::getFramebufferSize(g_window, &width, &height);
    if(height <= 0) {
        return;
    }
    g_ubo.model = matrix::IDENTITY4{float};
    g_ubo.view = matrix::look_at{float}({0.0, 5.0, 5.0}, {}, {0.0, 1.0, 0.0}).transpose();
    g_ubo.projection = matrix::perspective{float}((float)math::deg_to_rad(45), (float)width/(float)height, 0.1, 10000.0).transpose();
    g_ubo.time = 0.0;
    updateUniforms();
}

fn void? createDescriptorSets() {
    vk::DescriptorPoolSize ubo_size = {
        .type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
        .descriptor_count = MAX_FRAMES_IN_FLIGHT,
    };
    vk::DescriptorPoolSize sampler_size = {
        .type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
        .descriptor_count = MAX_FRAMES_IN_FLIGHT,
    };
    vk::DescriptorPoolSize[*] pool_sizes = {
        ubo_size,
        sampler_size,
    };
    vk::DescriptorPoolCreateInfo create_info = {
        .s_type         = vk::STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
        .pool_size_count = pool_sizes.len,
        .p_pool_sizes    = &pool_sizes,
        .max_sets       = MAX_FRAMES_IN_FLIGHT,
    };
    g_descriptor_pool = vk::createDescriptorPool(g_device, &create_info)!;
	vk::DescriptorSetLayout* set_layouts = (vk::DescriptorSetLayout*) malloc(vk::DescriptorSetLayout.sizeof* MAX_FRAMES_IN_FLIGHT);
	for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        set_layouts[i] = g_descriptor_set_layout;
    }
	vk::DescriptorSetAllocateInfo alloc_info = {
		.s_type              = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
		.descriptor_pool     = g_descriptor_pool,
		.descriptor_set_count = MAX_FRAMES_IN_FLIGHT,
		.p_set_layouts        = set_layouts,
	};
	vk::allocateDescriptorSets(g_device, &alloc_info, &g_descriptor_sets)!;
	for (uint i =0; i < MAX_FRAMES_IN_FLIGHT; i++) {
		vk::DescriptorBufferInfo uniform_buffer_info = {
			.buffer = g_uniform_buffers[i],
			.offset = 0,
			.range = UniformBuffer.sizeof,
		};
		vk::WriteDescriptorSet uniform_desc = {
    		.s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
    		.dst_set          = g_descriptor_sets[i],
    		.dst_binding      = 0,
    		.descriptor_type  = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
    		.descriptor_count = 1,
    		.p_buffer_info     = &uniform_buffer_info,
		};
		vk::DescriptorImageInfo texture_image_info = {
                .sampler = g_sampler,
                .image_view = g_texture_image_view,
                .image_layout = vk::IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
            };
		vk::WriteDescriptorSet sampler_desc = {
            .s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
            .dst_set          = g_descriptor_sets[i],
            .dst_binding      = 1,
            .descriptor_type  = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = 1,
            .p_image_info     = &texture_image_info,
		};
		vk::WriteDescriptorSet[*] descriptors = {
			uniform_desc,
			sampler_desc,
		};
		vk::updateDescriptorSets(g_device, descriptors.len, &descriptors, 0, null);
	}
}

fn void destroyDescriptorSets() {
	vk::destroyDescriptorPool(g_device, g_descriptor_pool, null);
}

fn void updateUniforms() {
    mem::copy(g_uniform_buffer_mapped[g_current_frame], &g_ubo, UniformBuffer.sizeof);
}

fn void? render() {
    vk::waitForFences(g_device, 1, &g_in_flight_fences[g_current_frame], vk::TRUE, ulong.max)!;
    uint? imageIndex = vk::acquireNextImageKHR(g_device, g_swap_chain, ulong.max, g_image_available_semaphore[g_current_frame]);
    if (catch excuse = imageIndex) {
        if (excuse == vk::error::ERROR_OUT_OF_DATE_KHR || excuse == vk::error::SUBOPTIMAL_KHR) {
            recreateSwapchain()!;
            return;
        }
        return excuse?;
    }
    vk::resetFences(g_device, 1, &g_in_flight_fences[g_current_frame])!;
    vk::resetCommandBuffer(g_command_buffers[g_current_frame], {})!;
    recordCommandBuffer(g_command_buffers[g_current_frame], imageIndex)!;
    vk::PipelineStageFlags wait_dst_stage_mask = {.color_attachment_output};
    vk::SubmitInfo submitInfo = {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .wait_semaphore_count = 1,
        .p_wait_semaphores = &g_image_available_semaphore[g_current_frame],
        .p_wait_dst_stage_mask = &wait_dst_stage_mask,
        .command_buffer_count = 1,
        .p_command_buffers = &g_command_buffers[g_current_frame],
        .signal_semaphore_count = 1,
        .p_signal_semaphores = &g_render_finished_semaphore[g_current_frame],
    };
    vk::queueSubmit(g_graphics_queue, 1, &submitInfo, g_in_flight_fences[g_current_frame])!;
    vk::PresentInfoKHR presentInfo = {
        .s_type = vk::STRUCTURE_TYPE_PRESENT_INFO_KHR,
        .wait_semaphore_count = 1,
        .p_wait_semaphores = &g_render_finished_semaphore[g_current_frame],
        .swapchain_count = 1,
        .p_swapchains = &g_swap_chain,
        .p_image_indices = &imageIndex,
    };
    fault excuse = @catch(vk::queuePresentKHR(g_present_queue, &presentInfo));
    if (excuse == vk::error::ERROR_OUT_OF_DATE_KHR || excuse == vk::error::SUBOPTIMAL_KHR) {
        recreateSwapchain()!;
    } else if (excuse) {
        return excuse?;
    }
    g_current_frame = (g_current_frame + 1) % MAX_FRAMES_IN_FLIGHT;
}

fn void? recordCommandBuffer(vk::CommandBuffer commandBuffer, uint imageIndex) {
    vk::CommandBufferBeginInfo beginInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
    };
    vk::beginCommandBuffer(commandBuffer, &beginInfo)!;
    vk::ImageMemoryBarrier barrier_before = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .old_layout = vk::IMAGE_LAYOUT_UNDEFINED,
        .new_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .src_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .image = g_swap_chain_images[imageIndex],
        .subresource_range = {
            .aspect_mask =  {.color},
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1
        },
        .src_access_mask = {},
        .dst_access_mask = {.color_attachment_write},
    };

    vk::cmdPipelineBarrier(
        commandBuffer,
        {.top_of_pipe},
        {.color_attachment_output},
        {},
        0, null,
        0, null,
        1, &barrier_before
    );

    // Begin dynamic rendering
    vk::RenderingAttachmentInfoKHR color_attachment = {
        .s_type = vk::STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO_KHR,
        .image_view = g_swap_chain_image_views[imageIndex],
        .image_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .load_op = vk::ATTACHMENT_LOAD_OP_CLEAR,
        .store_op = vk::ATTACHMENT_STORE_OP_STORE,
        .clear_value = { .color = { .float32 = {0.0117, 0.0117, 0.0179, 1.0} } }
    };

    vk::RenderingInfoKHR render_info = {
        .s_type = vk::STRUCTURE_TYPE_RENDERING_INFO_KHR,
        .render_area = {.extent = g_swap_chain_extent},
        .layer_count = 1,
        .color_attachment_count = 1,
        .p_color_attachments = &color_attachment
    };

    vk::cmdBeginRenderingKHR(commandBuffer, &render_info);
    vk::cmdBindPipeline(commandBuffer, vk::PIPELINE_BIND_POINT_GRAPHICS, g_graphics_pipeline);
    vk::Viewport viewport = {
        .width = g_swap_chain_extent.width,
        .height = g_swap_chain_extent.height,
        .max_depth = 1.0,
    };
    vk::cmdSetViewport(commandBuffer, 0, 1, &viewport);
    vk::Rect2D scissor = {
        .extent = g_swap_chain_extent,
    };
    vk::cmdSetScissor(commandBuffer, 0, 1, &scissor);
    draw(commandBuffer);
    vk::cmdEndRenderingKHR(commandBuffer);
    // Transition to PRESENT_SRC_KHR
    vk::ImageMemoryBarrier barrier_after = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .old_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .new_layout = vk::IMAGE_LAYOUT_PRESENT_SRC_KHR,
        .src_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .image = g_swap_chain_images[imageIndex],
        .subresource_range = {
            .aspect_mask = {.color},
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1
        },
        .src_access_mask = {.color_attachment_write},
        .dst_access_mask = {}
    };

    vk::cmdPipelineBarrier(
        commandBuffer,
        {.color_attachment_output},
        {.bottom_of_pipe},
        {},
        0, null,
        0, null,
        1, &barrier_after
    );
    vk::endCommandBuffer(commandBuffer)!;
}

fn void draw(vk::CommandBuffer commandBuffer) {
    vk::cmdBindVertexBuffers(commandBuffer, 0, 1, &g_vertex_buffer, &&(vk::DeviceSize)0);
    vk::cmdBindIndexBuffer(commandBuffer, g_index_buffer, 0, vk::INDEX_TYPE_UINT16);
    vk::cmdBindDescriptorSets(commandBuffer, vk::PIPELINE_BIND_POINT_GRAPHICS, g_pipeline_layout, 0, 1, &g_descriptor_sets[g_current_frame], 0, null);
    vk::cmdDrawIndexed(commandBuffer, INDICES.len, 1, 0, 0, 0);
}

fn void update() {
    g_ubo.time = (float)time::now().diff_sec(g_start_timestamp);
    g_ubo.model = matrix::IDENTITY4{float}
        .rotate_x((float)math::sin(g_ubo.time*0.53))
        .rotate_y((float)math::sin(g_ubo.time*0.97))
        .rotate_z((float)math::sin(g_ubo.time*1.17))
        .transpose();
    g_last_frame_timestamp = time::now();
    updateUniforms();
}

fn void? recreateSwapchain() {
    vk::deviceWaitIdle(g_device)!;
    destroySwapchain();
    createSwapchain()!;
}

fn void? init() {
    g_start_timestamp = time::now();
    g_last_frame_timestamp = g_start_timestamp;
    createVulkanInstance()!;
    createWindowSurface()!;
    pickPhysicalDevice()!;
    createLogicalDevice()!;
    createSwapchain()!;
    createDescriptorSetLayout()!;
    createGraphicsPipeline()!;
    createCommandPool()!;
    createBuffers()!;
    createDescriptorSets()!;
    createSemaphores()!;
    createUBO();
}

fn void destroy() {
    vk::deviceWaitIdle(g_device)!!;
    destroySemaphores();
    destroyBuffers();
    destroyCommandPool();
    destroyGraphicsPipeline();
    destroyDescriptorSetLayout();
    destroyDescriptorSets();
    destroySwapchain();
    destroyDevice();
    destroySurface();
    destroyVulkanInstance();
}
