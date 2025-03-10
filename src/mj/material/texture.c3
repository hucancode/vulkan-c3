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

fn void! Renderer.initTexture(this, Texture* texture, char[] data) {
    uint width, height;
    char* pixels = stbimage::load_from_memory(&data, data.len, &texture.width, &texture.height, &texture.channel, stbimage::RGB_ALPHA);
    uint channel = 4;
    texture.gpu.buffer = this.makeImageBuffer(pixels, vk::FORMAT_R8G8B8A8_SRGB, width, height, channel);
    texture.gpu.view = this.createImageView(texture.gpu.buffer)!;
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
    texture.gpu.sampler = vk::createSampler(this.device, &sampler_info)!;
}

fn void Renderer.destroyTexture(this, Texture* texture) {
    this.destroyImage(texture.gpu.buffer);
    vk::destroyImageView(this.device, texture.gpu.view);
    vk::destroySampler(this.device, texture.gpu.sampler);
}

fn vk::ImageView! Renderer.createImageView(this, ImageBuffer buffer) {
    vk::ImageView ret;
    vk::ImageViewCreateInfo info = {
        .s_type = vk::STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
        .image = buffer.image,
        .view_type = vk::IMAGE_VIEW_TYPE_2D,
        .format = buffer.format,
        .subresource_range = {
            .aspect_mask = { .color },
            .level_count = 1,
            .layer_count = 1,
        },
    };
    vk::createImageView(this.device, &info, null, &ret)!;
    return ret;
}
