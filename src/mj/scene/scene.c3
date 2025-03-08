module mj;
import std::collections::list;

struct Scene {
    Node root;
    Camera camera;
    Time last_frame_timestamp;
    Time start_timestamp;
}

struct SceneUniformData @align(16) {
	Matrix4x4(<float>) projection;
	Matrix4x4(<float>) view;
	float time;
}

struct SceneGPU {
    vk::Buffer buffer;
    vk::DeviceMemory buffer_memory;
    vk::DescriptorSetLayout descriptor_set_layout;
    vk::DescriptorSet[MAX_FRAMES_IN_FLIGHT] descriptor_sets;
}

struct GenerationalIndex {
    uint generation;
    uint index;
}

struct StaticMeshPool {
    List(<StaticMesh>) meshes;
}

struct SkeletalMeshPool {
    List(<SkeletalMesh>) meshes;
}

struct TexturePool {
    List(<Texture>) textures;
}

struct MaterialPool {
    List(<Material>) materials;
}
fn Scene make_scene() {
    Node root;
    Camera camera = {
        .projection = CameraProjection.PERSPECTIVE,
        .fov = 45.0,
        .aspect_ratio = 16.0 / 9.0,
        .near = 0.1,
        .far = 10000.0,
        .up = VEC_UP,
    };
    Time now = time::now();
    return Scene {
        .root = root,
        .camera = camera,
        .start_timestamp = now,
        .last_frame_timestamp = now,
    };
}

fn vk::DescriptorSetLayout! createSceneDescriptorSetLayout(Engine* engine) {
    vk::DescriptorSetLayoutBinding view = {
        .binding = 0,
        .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
        .descriptor_count = 1,
        .stage_flags = vk::ShaderStageFlags{.vertex},
    };
    vk::DescriptorSetLayoutBinding proj = {
        .binding = 1,
        .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
        .descriptor_count = 1,
        .stage_flags = vk::ShaderStageFlags{.vertex},
    };
    vk::DescriptorSetLayoutBinding time = {
        .binding = 2,
        .descriptor_type = vk::DESCRIPTOR_TYPE_UNIFORM_BUFFER,
        .descriptor_count = 1,
        .stage_flags = vk::ShaderStageFlags{.vertex},
    };
    vk::DescriptorSetLayoutBinding[*] bindings = { view, proj, time };
    vk::DescriptorSetLayoutCreateInfo info = {
        .s_type        = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
		.binding_count = bindings.len,
		.p_bindings    = &bindings,
	};
	return vk::createDescriptorSetLayout(engine.device, &info)!;
}

fn void! createSceneDescriptorSets(Engine* engine, SceneGPU* gpu) {
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
    gpu.descriptor_pool = vk::createDescriptorPool(engine.device, &create_info)!;
	vk::DescriptorSetLayout* set_layouts = (vk::DescriptorSetLayout*) malloc(vk::DescriptorSetLayout.sizeof* MAX_FRAMES_IN_FLIGHT);
	for (uint i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        set_layouts[i] = gpu.descriptor_set_layout;
    }
	vk::DescriptorSetAllocateInfo alloc_info = {
		.s_type              = vk::STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
		.descriptor_pool     = engine.descriptor_pool,
		.descriptor_set_count = MAX_FRAMES_IN_FLIGHT,
		.p_set_layouts        = set_layouts,
	};
	gpu.descriptor_sets = vk::allocateDescriptorSets(engine.device, &alloc_info)!;
}
