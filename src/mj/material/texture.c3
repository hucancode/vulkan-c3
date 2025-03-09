module mj;
import stbimage;

struct Texture {
    char* pixels;
    uint width;
    uint height;
    char channel;
    struct gpu {
        vk::ImageBuffer buffer;
        vk::Sampler sampler;
        vk::ImageView view;
    }
}

// const char[*] DATA = $embed("assets/statue-1275469_1280.jpg");
// defer stbimage::image_free(pixels);

fn void! createTexture(Engine* engine, Texture* texture, char[] data) {
    texture.pixels = stbimage::load_from_memory(&data, data.len, &texture.width, &texture.height, &texture.channel, stbimage::RGB_ALPHA);
    texture.channel = 4;
    usz size = texture.width * texture.height * texture.channel;
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
    texture.gpu.buffer = transferToImage(engine.device, &createMappedBuffer(engine, data.pixels, size), &create_info);
    texture.gpu.view = createImageView(texture.gpu.buffer.image, create_info.format)!;
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
    texture.gpu.sampler = vk::createSampler(engine.device, &sampler_info)!;
}

fn void destroyTexture(Texture* texture) {
    vk::destroyImage(engine.device, texture.gpu.image);
    vk::destroyImageView(engine.device, texture.gpu.view, null);
    vk::destroySampler(engine.device, texture.gpu.sampler, null);
}

fn vk::ImageView! createImageView(vk::Image image, vk::Format format) {
    vk::ImageView ret;
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
    vk::createImageView(engine.device, &info, null, &ret)!;
    return ret;
}
