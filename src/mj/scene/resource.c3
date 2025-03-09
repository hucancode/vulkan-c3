module mj;
import std::collections::list;
import std::core::mem;

bitstruct GenerationalHandle: uint {
    uint index: 0..23; // lower 24 bits for index, max 8_388_608 items
    char generation: 24..31; // upper 8 bits for generation, max 256 generations
}
distinct StaticMeshHandle = GenerationalHandle;
distinct SkeletalMeshHandle = GenerationalHandle;
distinct TextureHandle = GenerationalHandle;
distinct MaterialHandle = GenerationalHandle;
distinct NodeHandle = GenerationalHandle;

struct StaticMeshEntry {
    char generation;
    bool active;
    StaticMesh mesh;
}
struct SkeletalMeshEntry {
    char generation;
    bool active;
    SkeletalMesh mesh;
}
struct TextureEntry {
    char generation;
    bool active;
    Texture texture;
}
struct MaterialEntry {
    char generation;
    bool active;
    Material material;
}
struct NodeEntry {
    char generation;
    bool active;
    Node node;
}
struct ResourceManager {
    List(<StaticMeshEntry>) static_meshes;
    List(<uint>) static_meshes_free_indices;
    List(<SkeletalMeshEntry>) skeletal_meshes;
    List(<uint>) skeletal_meshes_free_indices;
    List(<SkeletalMeshEntry>) skeletal_meshes_gpu;
    List(<uint>) skeletal_meshes_gpu_free_indices;
    List(<TextureEntry>) textures;
    List(<uint>) textures_free_indices;
    List(<MaterialEntry>) materials;
    List(<uint>) materials_free_indices;
    List(<NodeEntry>) nodes;
    List(<uint>) nodes_free_indices;
}
fn StaticMeshHandle mallocStaticMesh(ResourceManager* rm) {
    if (rm.static_meshes_free_indices.empty()) {
        uint index = rm.static_meshes.size();
        rm.static_meshes.push({.generation = 0, .active = true});
        return {index, 0};
    }
    uint index = rm.static_meshes_free_indices.pop();
    char gen = rm.static_meshes[index].generation + 1;
    rm.static_meshes[index].generation = gen;
    rm.static_meshes[index].active = true;
    return {index, gen};
}

fn StaticMesh* getStaticMesh(ResourceManager* rm, StaticMeshHandle handle) {
    if (handle.index >= rm.static_meshes.size()) {
        return null;
    }
    char gen = rm.static_meshes[handle.index].generation;
    if (gen != handle.generation) {
        return null;
    }
    if (rm.static_meshes[handle.index].generation != gen) {
        return null;
    }
    return &rm.static_meshes[handle.index];
}

// WIP
