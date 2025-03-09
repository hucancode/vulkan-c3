module mj;
import std::collections::list;

struct Scene {
    Node root;
    Camera camera;
    Time last_frame_timestamp;
    Time start_timestamp;
    struct gpu {
        MappedBuffer[MAX_FRAMES_IN_FLIGHT] view_buffer;
        MappedBuffer[MAX_FRAMES_IN_FLIGHT] proj_buffer;
        MappedBuffer[MAX_FRAMES_IN_FLIGHT] time_buffer;
        vk::DescriptorPool descriptor_pool;
        vk::DescriptorSetLayout descriptor_set_layout;
        vk::DescriptorSet[MAX_FRAMES_IN_FLIGHT] descriptor_sets;
    }
}


// fn Scene make_scene() {
//     Node root;
//     Camera camera = {
//         .projection = CameraProjection.PERSPECTIVE,
//         .fov = 45.0,
//         .aspect_ratio = 16.0 / 9.0,
//         .near = 0.1,
//         .far = 10000.0,
//         .up = VEC_UP,
//     };
//     Time now = time::now();
//     return Scene {
//         .root = root,
//         .camera = camera,
//         .start_timestamp = now,
//         .last_frame_timestamp = now,
//     };
// }


fn Scene! createScene(Engine* engine) {
    Scene scene;
    {
        // scene-level descriptor set layout
        vk::DescriptorSetLayoutBinding view_proj = {
            .binding = 0,
            .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
            .descriptor_count = 1,
            .stage_flags = { .vertex },
        };
        vk::DescriptorSetLayoutBinding proj = {
            .binding = 1,
            .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
            .descriptor_count = 1,
            .stage_flags = { .vertex },
        };
        vk::DescriptorSetLayoutBinding time = {
            .binding = 2,
            .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
            .descriptor_count = 1,
            .stage_flags = { .vertex, .fragment },
        };
        vk::DescriptorSetLayoutBinding[*] bindings = { view, proj, time };
        vk::DescriptorSetLayoutCreateInfo info = {
            .s_type        = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
      		.binding_count = bindings.len,
      		.p_bindings    = &bindings,
       	};
       	scene.gpu.descriptor_set_layout = vk::createDescriptorSetLayout(engine.device, &info)!;
	}
	{
    	vk::DescriptorPoolSize view = {
            .type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
            .descriptor_count = MAX_FRAMES_IN_FLIGHT,
        };
        vk::DescriptorPoolSize proj = {
            .type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = MAX_FRAMES_IN_FLIGHT,
        };
        vk::DescriptorPoolSize time = {
            .type = vk::DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
            .descriptor_count = MAX_FRAMES_IN_FLIGHT,
        };
        vk::DescriptorPoolSize[*] pool_sizes = {
            view,
            proj,
            time,
        };
        vk::DescriptorPoolCreateInfo create_info = {
            .s_type         = vk::STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
            .pool_size_count = pool_sizes.len,
            .p_pool_sizes    = &pool_sizes,
            .max_sets       = MAX_FRAMES_IN_FLIGHT,
        };
        scene.gpu.descriptor_pool = vk::createDescriptorPool(engine.device, &create_info)!;
        vk::DescriptorSetLayout[] set_layouts = @repeat(&scene.gpu.descriptor_set_layout, MAX_FRAMES_IN_FLIGHT);
        defer free(set_layouts);
        vk::DescriptorSetAllocateInfo alloc_info = {
            .s_type              = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
            .descriptor_pool     = scene.gpu.descriptor_pool,
            .descriptor_set_count = set_layouts.len,
            .p_set_layouts        = &set_layouts,
        };
        scene.gpu.descriptor_sets = vk::allocateDescriptorSets(engine.device, &alloc_info)!;
	}
    for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        scene.gpu.view_buffer[i] = createMappedBuffer(engine, &Matrix4f.IDENTITY, Matrix4f.sizeof, { .uniform_buffer })!;
        scene.gpu.proj_buffer[i] = createMappedBuffer(engine, &Matrix4f.IDENTITY, Matrix4f.sizeof, { .uniform_buffer })!;
        scene.gpu.time_buffer[i] = createMappedBuffer(engine, &&0, float.sizeof, { .uniform_buffer })!;
    }
    return scene;
}

fn void Scene.pushDataToGPU(Scene* this, uint current_frame) {
    Time now = time::now();
    Matrix4f view = calculate_camera_lookat_matrix(this.camera);
    Matrix4f proj = calculate_camera_projection_matrix(this.camera);
    float t = (float)now.diff_sec(this.start_timestamp);
    writeToMappedBuffer(&view, this.gpu.view_buffer[current_frame]);
    writeToMappedBuffer(&proj, this.gpu.proj_buffer[current_frame]);
    writeToMappedBuffer(&t, this.gpu.time_buffer[current_frame]);
}
