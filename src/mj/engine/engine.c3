module mj;
import std::time;
import std::math::matrix;
import std::math;
import vk;

const ENGINE_NAME = "Mjolnir";
const TITLE = "Vulkan C3";

struct Engine {
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
    Time last_frame_timestamp;
    Time start_timestamp;
    uint current_frame;
}

fn void! init(Engine* engine, glfw::Window* window) {
    engine.start_timestamp = time::now();
    engine.last_frame_timestamp = engine.start_timestamp;
    vkbe::createVulkanInstance()!;
    vkbe::createWindowSurface()!;
    vkbe::pickPhysicalDevice()!;
    vkbe::createLogicalDevice()!;
    vkbe::createSwapchain()!;
    vkbe::createSemaphores()!;
    vkbe::createCommandPool()!;
    vkbe::createUBO();
}

fn void destroy(Engine* engine) {
    vk::deviceWaitIdle(engine.device)!!;
    vkbe::destroySemaphores();
    vkbe::destroyCommandPool();
    vkbe::destroyGraphicsPipeline();
    vkbe::destroyDescriptorSetLayout();
    vkbe::destroyDescriptorSets();
    vkbe::destroySwapchain();
    vkbe::destroyDevice();
    vkbe::destroySurface();
    vkbe::destroyVulkanInstance();
}

fn void update(Engine* engine) {
    engine.ubo.time = (float)time::now().diff_sec(g_start_timestamp);
    engine.ubo.model = matrix::IDENTITY4(<float>)
        .rotate_x((float)math::sin(g_ubo.time*0.53))
        .rotate_y((float)math::sin(g_ubo.time*0.97))
        .rotate_z((float)math::sin(g_ubo.time*1.17))
        .transpose();
    engine.last_frame_timestamp = time::now();
    vkbe::updateUniforms();
}

const ZString[*] REQUIRED_EXTENSIONS = {
    vk::KHR_SWAPCHAIN_EXTENSION_NAME,
    vk::KHR_DYNAMIC_RENDERING_EXTENSION_NAME,
};
const ENABLE_VALIDATION_LAYERS = false;
const ZString[*] VALIDATION_LAYERS @if(ENABLE_VALIDATION_LAYERS) = {
    "VK_LAYER_KHRONOS_validation",
};

const MAX_FRAMES_IN_FLIGHT = 2;

fn void! createVulkanInstance(Engine* engine) {
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
        vk::ExtensionProperties[]! extensions = vk::enumerateDeviceExtensionProperties(device, null);
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
        g_swap_chain_image_views[i] = createImageView(g_swap_chain_images[i], g_swap_chain_format.format)!;
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

fn void! recreateSwapchain() {
    vk::deviceWaitIdle(g_device)!;
    destroySwapchain();
    createSwapchain()!;
}

fn uint! findMemoryType(uint filter, vk::MemoryPropertyFlags flags) {
    vk::PhysicalDeviceMemoryProperties props;
    vk::getPhysicalDeviceMemoryProperties(g_physical_device, &props);
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

fn void allocateMemory(vk::Device device, vk::MemoryRequirements req, vk::MemoryPropertyFlags properties, vk::DeviceMemory* memory) {
    vk::MemoryAllocateInfo info{
        .s_type = vk::STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
        .allocation_size = req.size,
        .memory_type_index = findMemoryType(req.memory_type_bits, properties)!,
    };
    vk::allocateMemory(device, &info, null, memory)!;
}

vk::Semaphore[MAX_FRAMES_IN_FLIGHT] g_image_available_semaphore;
vk::Semaphore[MAX_FRAMES_IN_FLIGHT] g_render_finished_semaphore;
vk::Fence[MAX_FRAMES_IN_FLIGHT] g_in_flight_fences;

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

vk::Buffer[MAX_FRAMES_IN_FLIGHT] g_uniform_buffers;
vk::DeviceMemory[MAX_FRAMES_IN_FLIGHT] g_uniform_memory;
void*[MAX_FRAMES_IN_FLIGHT] g_uniform_buffer_mapped;


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
    vk::ImageMemoryBarrier barrier_before = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER,
        .old_layout = vk::IMAGE_LAYOUT_UNDEFINED,
        .new_layout = vk::IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .src_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk::QUEUE_FAMILY_IGNORED,
        .image = g_swap_chain_images[imageIndex],
        .subresource_range = {
            .aspect_mask = vk::ImageAspectFlags {.color},
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1
        },
        .src_access_mask = vk::AccessFlags{},
        .dst_access_mask = vk::AccessFlags{.color_attachment_write},
    };

    vk::cmdPipelineBarrier(
        commandBuffer,
        vk::PipelineStageFlags{.top_of_pipe},
        vk::PipelineStageFlags{.color_attachment_output},
        vk::DependencyFlags{},
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
    vk::cmdSetViewport(commandBuffer, 0, 1, &&vk::Viewport {
        .width = g_swap_chain_extent.width,
        .height = g_swap_chain_extent.height,
        .max_depth = 1.0,
    });
    vk::cmdSetScissor(commandBuffer, 0, 1, &&vk::Rect2D {
        .extent = g_swap_chain_extent,
    });
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
            .aspect_mask = vk::ImageAspectFlags{.color},
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = 1
        },
        .src_access_mask = vk::AccessFlags{.color_attachment_write},
        .dst_access_mask = vk::AccessFlags{}
    };

    vk::cmdPipelineBarrier(
        commandBuffer,
        vk::PipelineStageFlags{.color_attachment_output},
        vk::PipelineStageFlags{.bottom_of_pipe},
        vk::DependencyFlags{},
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
