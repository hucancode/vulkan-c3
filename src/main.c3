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
import vk;

const WIDTH = 1024;
const HEIGHT = 768;
const TITLE = "Hello Vulkan!";
const ENGINE_NAME = "Soreal Engine";
const ZString[*] REQUIRED_EXTENSIONS = {
    vk::KHR_SWAPCHAIN_EXTENSION_NAME,
};
const ENABLE_VALIDATION_LAYERS = true;
const ZString[*] VALIDATION_LAYERS @if(ENABLE_VALIDATION_LAYERS) = {
    "VK_LAYER_KHRONOS_validation",
};
const char[*] VERTEX_CODE = $embed("shaders/vert.spv");
const char[*] FRAGMENT_CODE = $embed("shaders/frag.spv");

const MAX_FRAMES_IN_FLIGHT = 2;
const Vertex[] VERTICES = {
	// Front-top-left
	{.position = {-1.0, 1.0, 1.0, 1.0}, .color = {0.25, 0.25, 0.5, 1.0}},
	// Front-top-right
	{.position = {1.0, 1.0, 1.0, 1.0}, .color = {0.5, 0.5, 0.0, 1.0}},
	// Front-bottom-right
	{.position = {1.0, -1.0, 1.0, 1.0}, .color = {0.0, 0.5, 0.5, 1.0}},
	// Front-bottom-left
	{.position = {-1.0, -1.0, 1.0, 1.0}, .color = {0.5, 1.0, 0.5, 1.0}},
	// Back-top-left
	{.position = {-1.0, 1.0, -1.0, 1.0}, .color = {1.0, 0.5, 0.0, 1.0}},
	// Back-top-right
	{.position = {1.0, 1.0, -1.0, 1.0}, .color = {0.5, 0.5, 0.5, 1.0}},
	// Back-bottom-right
	{.position = {1.0, -1.0, -1.0, 1.0}, .color = {0.5, 0.5, 0.5, 1.0}},
	// Back-bottom-left
	{.position = {-1.0, -1.0, -1.0, 1.0}, .color = {0.25, 0.25, 1.0, 1.0}},
};

const ushort[] INDICES = {
	// Front face
	0,
	2,
	1,
	0,
	3,
	2,
	// Right face
	1,
	6,
	5,
	1,
	2,
	6,
	// Back face
	5,
	7,
	4,
	5,
	6,
	7,
	// Left face
	4,
	3,
	0,
	4,
	7,
	3,
	// Top face
	4,
	1,
	5,
	4,
	0,
	1,
	// Bottom face
	3,
	6,
	2,
	3,
	7,
	6,
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
vk::Framebuffer[] g_swap_chain_framebuffers;

vk::RenderPass g_render_pass;
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
time::Time g_last_frame_timestamp;
time::Time g_start_timestamp;
UniformBufferObject g_ubo;

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
        anyfault excuse = @catch(render());
        if (excuse) {
            io::printfn("Error: while rendering");
        };
    }
    return 0;
}

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

fn void! createWindowSurface() {
    vk::check(glfw::createWindowSurface(g_instance, g_window, null, &g_surface))!;
}

fn void destroySurface() {
    vk::destroySurfaceKHR(g_instance, g_surface, null);
}

fn uint scorePhysicalDevice(vk::PhysicalDevice device) {
    uint score = 0;
    vk::PhysicalDeviceProperties properties;
    vk::PhysicalDeviceFeatures features;
    vk::getPhysicalDeviceProperties(device, &properties);
    ZString deviceName = (ZString)properties.device_name[0..];
    io::printfn("Scoring device %s", deviceName);
    defer io::printfn("Device %s scored %d", score);
    vk::getPhysicalDeviceFeatures(device, &features);
    $if !env::DARWIN:
        if (!features.geometry_shader) {
            return 0;
        }
    $endif
    {
        vk::ExtensionProperties[]! extensions = vk::enumerateInstanceExtensionProperties(null);
        if (catch excuse = extensions) {
            io::printfn("Cound not get extension list for %s", deviceName);
            return 0;
        }
        defer free(extensions);
        foreach (required: REQUIRED_EXTENSIONS) {
            bool found = false;
            foreach (e : extensions) {
                ZString name = (ZString)e.extension_name[0..];
                if (name == required) {
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
        SwapchainSupportDetails! support = querySwapchainSupport(device);
        if (catch excuse = support) {
            io::printfn("Cound not get swapchain support for %s", deviceName);
            return 0;
        }
        support.free();
    }
    {
        QueueFamilyIndices! indices = findQueueFamilies(device);
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

fn void! pickPhysicalDevice() {
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

fn SwapchainSupportDetails! querySwapchainSupport(vk::PhysicalDevice device) {
    SwapchainSupportDetails ret;
    vk::getPhysicalDeviceSurfaceCapabilitiesKHR(device, g_surface, &ret.capabilities)!;
    ret.formats = vk::getPhysicalDeviceSurfaceFormatsKHR(device, g_surface)!;
    ret.present_modes = vk::getPhysicalDeviceSurfacePresentModesKHR(device, g_surface)!;
    return ret;
}

struct QueueFamilyIndices {
    uint graphics_family;
    uint present_family;
}

fn QueueFamilyIndices! findQueueFamilies(vk::PhysicalDevice device) {
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
    return vk::VulkanError.ERROR_UNKNOWN?;
}

fn void! createLogicalDevice() {
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
    vk::createDevice(g_physical_device, &createInfo, null, &g_device)!;
    vk::getDeviceQueue(g_device, indices.graphics_family, 0, &g_graphics_queue);
    vk::getDeviceQueue(g_device, indices.present_family, 0, &g_present_queue);
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

fn void! createSwapchain() {
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
        .image_usage = vk::ImageUsageFlags { .color_attachment },
        .image_sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
        .queue_family_index_count = 2,
        .p_queue_family_indices = &indiceArray,
        .pre_transform = swapChainSupport.capabilities.current_transform,
        .composite_alpha = vk::CompositeAlphaFlagsKHR { .opaque },
        .present_mode = presentMode,
        .clipped = (uint)true,
    };
    if (indices.graphics_family != indices.present_family) {
        createInfo.image_sharing_mode = vk::SHARING_MODE_CONCURRENT;
        createInfo.queue_family_index_count = indiceArray.len;
        createInfo.p_queue_family_indices = &indiceArray;
    }
    vk::createSwapchainKHR(g_device, &createInfo, null, &g_swap_chain)!;
    g_swap_chain_images = vk::getSwapchainImagesKHR(g_device, g_swap_chain)!;
    vk::ImageView* buffer = (vk::ImageView*)malloc(g_swap_chain_images.len * vk::ImageView.sizeof);
    g_swap_chain_image_views = buffer[:g_swap_chain_images.len];
    for (uint i = 0; i < g_swap_chain_images.len; i++) {
        vk::ImageViewCreateInfo info = {
            .s_type = vk::STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
            .image = g_swap_chain_images[i],
            .view_type = vk::IMAGE_VIEW_TYPE_2D,
            .format = g_swap_chain_format.format,
            .subresource_range = {
                .aspect_mask = vk::ImageAspectFlags { .color },
                .level_count = 1,
                .layer_count = 1,
            },
        };
        vk::createImageView(g_device, &info, null, &g_swap_chain_image_views[i])!;
    }
}

fn void destroySwapchain() {
    foreach (view:g_swap_chain_image_views) {
        vk::destroyImageView(g_device, view, null);
    }
    vk::destroySwapchainKHR(g_device, g_swap_chain, null);
    free(g_swap_chain_image_views);
    free(g_swap_chain_images);
}

fn vk::ShaderModule! createShaderModule(char[] code) {
    vk::ShaderModuleCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO,
        .code_size = code.len,
        .p_code = (uint*)code.ptr,
    };
    vk::ShaderModule ret;
    vk::createShaderModule(g_device, &createInfo, null, &ret)!;
    return ret;
}

fn void! createRenderPass() {
    vk::RenderPassCreateInfo createInfo = {
        .s_type = vk::STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO,
        .attachment_count = 1,
        .p_attachments = &&vk::AttachmentDescription {
            .format = g_swap_chain_format.format,
            .samples = vk::SampleCountFlags { .n_1 },
            .load_op = vk::ATTACHMENT_LOAD_OP_CLEAR,
            .store_op = vk::ATTACHMENT_STORE_OP_STORE,
            .stencil_load_op = vk::ATTACHMENT_LOAD_OP_DONT_CARE,
            .stencil_store_op = vk::ATTACHMENT_STORE_OP_DONT_CARE,
            .initial_layout = vk::IMAGE_LAYOUT_UNDEFINED,
            .final_layout = vk::IMAGE_LAYOUT_PRESENT_SRC_KHR,
        },
        .subpass_count = 1,
        .p_subpasses = &&vk::SubpassDescription {
            .pipeline_bind_point = vk::PIPELINE_BIND_POINT_GRAPHICS,
            .color_attachment_count = 1,
            .p_color_attachments = &&vk::AttachmentReference {
                .attachment = 0,
                .layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
            },
        },
        .dependency_count = 1,
        .p_dependencies = &&vk::SubpassDependency {
            .src_subpass = vk::SUBPASS_EXTERNAL,
            .dst_subpass = 0,
            .src_stage_mask = vk::PipelineStageFlags { .color_attachment_output },
            .src_access_mask = vk::AccessFlags { .color_attachment_write },
            .dst_stage_mask = vk::PipelineStageFlags { .color_attachment_output },
            .dst_access_mask = vk::AccessFlags { .color_attachment_write },
            .dependency_flags = vk::DependencyFlags { .by_region },
        },
    };
    io::printfn("PipelineStageFlags::color_attachment_output = 0x%x", (uint)vk::PipelineStageFlags { .color_attachment_output });
    vk::createRenderPass(g_device, &createInfo, null, &g_render_pass)!;
}

fn void destroyRenderPass() {
    vk::destroyRenderPass(g_device, g_render_pass, null);
}

fn void! createFrameBuffers() {
    uint n = g_swap_chain_image_views.len;
    vk::Framebuffer* buffers = (vk::Framebuffer*)malloc(n * vk::Framebuffer.sizeof);
    g_swap_chain_framebuffers = buffers[:n];
    for (uint i = 0; i < n; i++) {
        vk::FramebufferCreateInfo info = {
            .s_type = vk::STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO,
            .render_pass = g_render_pass,
            .attachment_count = 1,
            .p_attachments = &g_swap_chain_image_views[i],
            .width = g_swap_chain_extent.width,
            .height = g_swap_chain_extent.height,
            .layers = 1,
        };
        vk::createFramebuffer(g_device, &info, null, &g_swap_chain_framebuffers[i])!;
    }
}

fn void destroyFrameBuffers() {
    foreach (buffer : g_swap_chain_framebuffers) {
        vk::destroyFramebuffer(g_device, buffer, null);
    }
    free(g_swap_chain_framebuffers);
}

fn void! createDescriptorSetLayout() {
	vk::DescriptorSetLayoutCreateInfo info = {
		.s_type        = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
		.binding_count = 1,
		.p_bindings    = &&vk::DescriptorSetLayoutBinding {
			.binding = 0,
			.descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
			.descriptor_count = 1,
			.stage_flags = vk::ShaderStageFlags{.vertex},
		},
	};
	vk::createDescriptorSetLayout(
		g_device,
		&info,
		null,
		&g_descriptor_set_layout,
	)!;
}

fn void destroyDescriptorSetLayout() {
    vk::destroyDescriptorSetLayout(g_device, g_descriptor_set_layout, null);
}

fn void! createGraphicsPipeline() {
    vk::ShaderModule v = createShaderModule(&VERTEX_CODE)!;
    defer vk::destroyShaderModule(g_device, v, null);
    vk::ShaderModule f = createShaderModule(&FRAGMENT_CODE)!;
    defer vk::destroyShaderModule(g_device, f, null);
    vk::PipelineShaderStageCreateInfo[*] shader_stages = {{
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk::ShaderStageFlags { .vertex },
        .module_ = v,
        .p_name = "main",
    }, {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk::ShaderStageFlags { .fragment },
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
	   .binding = 0, .location = 3, .format = vk::FORMAT_R32G32_SFLOAT, .offset = Vertex.texCoord.offsetof
	}};
	io::printfn("vertex size %d, position offset %d, color offset %d, normal offset %d, texcoord offset %d",
	Vertex.sizeof, Vertex.position.offsetof, Vertex.color.offsetof, Vertex.normal.offsetof, Vertex.texCoord.offsetof);
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
        .cull_mode = vk::CullModeFlags { .back },
        .front_face = vk::FRONT_FACE_CLOCKWISE,
        .line_width = 1.0,
    };
    vk::PipelineMultisampleStateCreateInfo multisampling = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
        .rasterization_samples = vk::SampleCountFlags { .n_1 },
        .min_sample_shading = 1.0,
    };
    vk::PipelineColorBlendAttachmentState colorBlendAttachment = {
        .color_write_mask = vk::ColorComponentFlags { .r, .g, .b, .a },
    };
    vk::PipelineColorBlendStateCreateInfo colorBlending = {
        .s_type = vk::STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
        .attachment_count = 1,
        .p_attachments = &colorBlendAttachment,
    };
    vk::createPipelineLayout(
        g_device,
        &&vk::PipelineLayoutCreateInfo {
            .s_type = vk::STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
            .set_layout_count = 1,
            .p_set_layouts = &g_descriptor_set_layout,
        },
        null,
        &g_pipeline_layout)!;
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
        .render_pass = g_render_pass,
        .subpass = 0,
        .base_pipeline_index = -1,
    };
    vk::createGraphicsPipelines(g_device, (vk::PipelineCache)0, 1, &pipelineInfo, null, &g_graphics_pipeline)!;
}

fn void destroyGraphicsPipeline() {
    vk::destroyPipeline(g_device, g_graphics_pipeline, null);
    vk::destroyPipelineLayout(g_device, g_pipeline_layout, null);
}

fn void! createCommandPool() {
    QueueFamilyIndices queueFamilyIndices = findQueueFamilies(g_physical_device)!;
    vk::CommandPoolCreateInfo poolInfo = {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .flags = vk::CommandPoolCreateFlags { .reset_command_buffer },
        .queue_family_index = queueFamilyIndices.graphics_family,
    };
    vk::createCommandPool(g_device, &poolInfo, null, &g_command_pool)!;
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

fn void! createSemaphores() {
    vk::SemaphoreCreateInfo semaphoreInfo = {
        .s_type = vk::STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO,
    };
    vk::FenceCreateInfo fenceInfo = {
        .s_type = vk::STRUCTURE_TYPE_FENCE_CREATE_INFO,
        .flags = vk::FenceCreateFlags { .signaled },
    };
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::createSemaphore(g_device, &semaphoreInfo, null, &g_image_available_semaphore[i])!;
        vk::createSemaphore(g_device, &semaphoreInfo, null, &g_render_finished_semaphore[i])!;
        vk::createFence(g_device, &fenceInfo, null, &g_in_flight_fences[i])!;
    }
}

fn void destroySemaphores() {
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vk::destroySemaphore(g_device, g_image_available_semaphore[i], null);
        vk::destroySemaphore(g_device, g_render_finished_semaphore[i], null);
        vk::destroyFence(g_device, g_in_flight_fences[i], null);
    }
}

fn uint! findMemoryType(vk::PhysicalDevice device, uint filter, vk::MemoryPropertyFlags flags) {
    vk::PhysicalDeviceMemoryProperties props;
    vk::getPhysicalDeviceMemoryProperties(device, &props);
    for (uint i = 0; i < props.memory_type_count; i++) {
        if (filter & (1 << i) == 0) {
            continue;
        }
        if ((props.memory_types[i].property_flags & flags) != flags) {
            continue;
        }
        return i;
    }
    return vk::VulkanError.ERROR_UNKNOWN?;
}
fn void! createBuffer(vk::DeviceSize size, vk::BufferUsageFlags usage, vk::MemoryPropertyFlags properties, vk::Buffer* buffer, vk::DeviceMemory* memory) {
    vk::BufferCreateInfo bufferInfo = {
        .s_type = vk::STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .size = size,
        .usage = usage,
        .sharing_mode = vk::SHARING_MODE_EXCLUSIVE,
    };
    vk::createBuffer(g_device, &bufferInfo, null, buffer)!;
    vk::MemoryRequirements requirements;
    vk::getBufferMemoryRequirements(g_device, *buffer, &requirements);
    vk::MemoryAllocateInfo allocInfo = {
        .s_type = vk::STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        .allocation_size = requirements.size,
        .memory_type_index = findMemoryType(g_physical_device, requirements.memory_type_bits, properties)!,
    };
    vk::allocateMemory(g_device, &allocInfo, null, memory)!;
    vk::bindBufferMemory(g_device, *buffer, *memory, 0)!;
}

fn void! copyBuffer(vk::Buffer dst, vk::Buffer src, vk::DeviceSize size) {
    vk::CommandBuffer command_buffer;
    vk::allocateCommandBuffers(g_device, &&vk::CommandBufferAllocateInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        .level = vk::COMMAND_BUFFER_LEVEL_PRIMARY,
        .command_pool = g_command_pool,
        .command_buffer_count = 1,
    }, &command_buffer)!;
    defer vk::freeCommandBuffers(g_device, g_command_pool, 1, &command_buffer);
    vk::beginCommandBuffer(command_buffer, &&vk::CommandBufferBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
        .flags = vk::CommandBufferUsageFlags { .one_time_submit },
    })!;
    vk::cmdCopyBuffer(command_buffer, src, dst, 1, &&vk::BufferCopy { .size = size });
    vk::endCommandBuffer(command_buffer)!;
    vk::queueSubmit(g_graphics_queue, 1, &&vk::SubmitInfo {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .command_buffer_count = 1,
        .p_command_buffers = &command_buffer,
    }, (vk::Fence)0)!;
    vk::queueWaitIdle(g_graphics_queue)!;
}

fn void! createBufferInit(void* data, vk::DeviceSize size, vk::BufferUsageFlags usage, vk::MemoryPropertyFlags flags, vk::Buffer* buffer, vk::DeviceMemory* memory) {
    vk::Buffer stg_buffer;
    vk::DeviceMemory stg_memory;
    createBuffer(size, vk::BufferUsageFlags { .transfer_src }, vk::MemoryPropertyFlags { .host_visible, .host_coherent }, &stg_buffer, &stg_memory)!;
    defer {
        vk::destroyBuffer(g_device, stg_buffer, null);
        vk::freeMemory(g_device, stg_memory, null);
    }
    void* mapped;
    vk::mapMemory(g_device, stg_memory, 0, size, vk::MemoryMapFlags{}, &mapped)!;
    defer vk::unmapMemory(g_device, stg_memory);
    mem::copy(mapped, data, (usz)size);
    createBuffer(size, vk::BufferUsageFlags { .transfer_dst } | usage, flags, buffer, memory)!;
    copyBuffer(*buffer, stg_buffer, size)!;
}

fn void! createBuffers() {
    io::printfn("Vertex size: %d, Indices size: %d", Vertex.sizeof*VERTICES.len, ushort.sizeof*INDICES.len);
    createBufferInit(VERTICES.ptr, (vk::DeviceSize)(Vertex.sizeof*VERTICES.len), vk::BufferUsageFlags { .vertex_buffer }, vk::MemoryPropertyFlags { .device_local }, &g_vertex_buffer, &g_vertex_memory)!;
    createBufferInit(INDICES.ptr, (vk::DeviceSize)(ushort.sizeof*INDICES.len), vk::BufferUsageFlags { .index_buffer }, vk::MemoryPropertyFlags { .device_local }, &g_index_buffer, &g_index_memory)!;
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        createBufferInit(&g_ubo, UniformBufferObject.sizeof, vk::BufferUsageFlags { .uniform_buffer }, vk::MemoryPropertyFlags { .host_visible, .host_coherent }, &g_uniform_buffers[i], &g_uniform_memory[i])!;
        vk::mapMemory(g_device, g_uniform_memory[i], 0, UniformBufferObject.sizeof, vk::MemoryMapFlags{}, &g_uniform_buffer_mapped[i])!;
    }
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
}

fn void createUBO() {
    int width, height;
    glfw::getFramebufferSize(g_window, &width, &height);
    if(height <= 0) {
        return;
    }
    g_ubo.model = MATRIX4F_IDENTITY;
    g_ubo.view = matrix::look_at(<float>)({0.0, 5.0, 5.0}, {}, {0.0, 1.0, 0.0}).transpose();
    g_ubo.projection = matrix::perspective(<float>)((float)math::deg_to_rad(45), (float)width/(float)height, 0.1, 10000.0).transpose();
    g_ubo.time = 0.0;
    updateUniforms();
}

fn void! createDescriptorSets() {
	vk::DescriptorPoolCreateInfo create_info = {
		.s_type         = vk::STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
		.pool_size_count = 1,
		.p_pool_sizes    = &&vk::DescriptorPoolSize {
			.type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
			.descriptor_count = MAX_FRAMES_IN_FLIGHT,
		},
		.max_sets       = MAX_FRAMES_IN_FLIGHT,
	};
	vk::createDescriptorPool(g_device, &create_info, null, &g_descriptor_pool)!;
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
		vk::WriteDescriptorSet descriptor_write = {
    		.s_type           = vk::STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET,
    		.dst_set          = g_descriptor_sets[i],
    		.dst_binding      = 0,
    		.descriptor_type  = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
    		.descriptor_count = 1,
    		.p_buffer_info     = &&vk::DescriptorBufferInfo {
    			.buffer = g_uniform_buffers[i],
    			.offset = 0,
    			.range = UniformBufferObject.sizeof,
			},
		};
		vk::updateDescriptorSets(g_device, 1, &descriptor_write, 0, null);
	}
}

fn void destroyDescriptorSets() {
	vk::destroyDescriptorPool(g_device, g_descriptor_pool, null);
}

fn void updateUniforms() {
    mem::copy(g_uniform_buffer_mapped[g_current_frame], &g_ubo, UniformBufferObject.sizeof);
}

fn void! render() {
    vk::waitForFences(g_device, 1, &g_in_flight_fences[g_current_frame], vk::TRUE, ulong.max)!;
    uint imageIndex;
    anyfault excuse = @catch(vk::acquireNextImageKHR(g_device, g_swap_chain, ulong.max, g_image_available_semaphore[g_current_frame], (vk::Fence)0, &imageIndex));
    if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
        recreateSwapchain()!;
        return;
    }
    if (excuse) {
        return excuse?;
    }
    vk::resetFences(g_device, 1, &g_in_flight_fences[g_current_frame])!;
    vk::resetCommandBuffer(g_command_buffers[g_current_frame], CommandBufferResetFlags{})!;
    recordCommandBuffer(g_command_buffers[g_current_frame], imageIndex)!;

    vk::SubmitInfo submitInfo = {
        .s_type = vk::STRUCTURE_TYPE_SUBMIT_INFO,
        .wait_semaphore_count = 1,
        .p_wait_semaphores = &g_image_available_semaphore[g_current_frame],
        .p_wait_dst_stage_mask = &&vk::PipelineStageFlags { .color_attachment_output },
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
    excuse = @catch(vk::queuePresentKHR(g_present_queue, &presentInfo));
    if (excuse == vk::VulkanError.ERROR_OUT_OF_DATE_KHR || excuse == vk::VulkanError.SUBOPTIMAL_KHR) {
        recreateSwapchain()!;
    } else if (excuse) {
        return excuse?;
    }
    g_current_frame = (g_current_frame + 1) % MAX_FRAMES_IN_FLIGHT;
}

fn void! recordCommandBuffer(vk::CommandBuffer commandBuffer, uint imageIndex) {
    vk::beginCommandBuffer(commandBuffer, &&vk::CommandBufferBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
    })!;
    vk::cmdBeginRenderPass(commandBuffer, &&vk::RenderPassBeginInfo {
        .s_type = vk::STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO,
        .render_pass = g_render_pass,
        .framebuffer = g_swap_chain_framebuffers[imageIndex],
        .render_area = { .extent = g_swap_chain_extent },
        .clear_value_count = 1,
        .p_clear_values = &&vk::ClearValue { .color = { .float32 = float[4] { 0.0117, 0.0117, 0.0179, 1.0 } } },
    }, vk::SUBPASS_CONTENTS_INLINE);
    vk::cmdBindPipeline(commandBuffer, vk::PIPELINE_BIND_POINT_GRAPHICS, g_graphics_pipeline);
    vk::cmdSetViewport(commandBuffer, 0, 1, &&vk::Viewport {
        .width = g_swap_chain_extent.width,
        .height = g_swap_chain_extent.height,
        .max_depth = 1.0,
    });
    vk::cmdSetScissor(commandBuffer, 0, 1, &&vk::Rect2D {
        .extent = g_swap_chain_extent,
    });
    draw(commandBuffer);
    vk::cmdEndRenderPass(commandBuffer);
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
    g_ubo.model = MATRIX4F_IDENTITY
        .rotate_x((float)math::sin((float)g_ubo.time*0.53))
        .rotate_y((float)math::sin((float)g_ubo.time*0.97))
        .rotate_z((float)math::sin((float)g_ubo.time*1.17))
        .transpose();
    g_last_frame_timestamp = time::now();
    updateUniforms();
}

fn void! recreateSwapchain() {
    vk::deviceWaitIdle(g_device)!;
    destroyFrameBuffers();
    destroySwapchain();
    createSwapchain()!;
    createFrameBuffers()!;
}

fn void! init() {
    g_start_timestamp = time::now();
    g_last_frame_timestamp = g_start_timestamp;
    createVulkanInstance()!;
    createWindowSurface()!;
    pickPhysicalDevice()!;
    createLogicalDevice()!;
    createSwapchain()!;
    io::printfn("Swap chain created %x", g_swap_chain);
    createRenderPass()!;
    io::printfn("Render pass created %x", g_render_pass);
    createDescriptorSetLayout()!;
    io::printfn("Descriptor set layout created %x", g_descriptor_set_layout);
    createFrameBuffers()!;
    io::printfn("Frame buffers created %x", g_swap_chain_framebuffers.len);
    createGraphicsPipeline()!;
    io::print("Graphics pipeline created\n");
    createCommandPool()!;
    io::print("Command pool created\n");
    createBuffers()!;
    io::print("Buffers created\n");
    createDescriptorSets()!;
    io::print("Descriptor sets created\n");
    createSemaphores()!;
    io::print("Semaphores created\n");
    createUBO();
}

fn void destroy() {
    vk::deviceWaitIdle(g_device)!!;
    destroySemaphores();
    destroyBuffers();
    destroyCommandPool();
    destroyGraphicsPipeline();
    destroyFrameBuffers();
    destroyDescriptorSetLayout();
    destroyRenderPass();
    destroyDescriptorSets();
    destroySwapchain();
    destroyDevice();
    destroySurface();
    destroyVulkanInstance();
}
