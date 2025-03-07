module std::core::env;
const bool GLFW_INCLUDE_VULKAN = true;
module mj;
import std::io;
import vk;
import glfw;

const ZString[*] REQUIRED_EXTENSIONS = {
    vk::KHR_SWAPCHAIN_EXTENSION_NAME,
    vk::KHR_DYNAMIC_RENDERING_EXTENSION_NAME,
};
const ENABLE_VALIDATION_LAYERS = false;
const ZString[*] VALIDATION_LAYERS @if(ENABLE_VALIDATION_LAYERS) = {
    "VK_LAYER_KHRONOS_validation",
};

const MAX_FRAMES_IN_FLIGHT = 2;

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
