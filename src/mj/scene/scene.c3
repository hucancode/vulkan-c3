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
