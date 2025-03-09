module mj;
import std::collections::list;

struct ResourceManager {
    List(<StaticMesh>) static_meshes_cpu;
    List(<StaticMeshGPU>) static_meshes_gpu;
    List(<SkeletalMesh>) skeletal_meshes_cpu;
    List(<SkeletalMeshGPU>) skeletal_meshes_gpu;
    List(<Texture>) textures_cpu;
    List(<TextureGPU>) textures_gpu;
    List(<Material>) materials_cpu;
    List(<MaterialGPU>) materials_gpu;
    TexturePool textures;
    MaterialPool materials;
    List(<Node>) nodes;
}

// struct GenerationalIndex {
//     uint generation;
//     uint index;
// }


fn StaticMeshGPU* getStaticMeshGPU(ResourceManager* rm, StaticMeshHandle handle) {
    return &rm.static_meshes_gpu[handle];
}

fn MaterialGPU* getMaterialGPU(ResourceManager* rm, MaterialHandle handle) {
    return &rm.materials_gpu[handle];
}

fn Node* getNode(ResourceManager* rm, NodeHandle handle) {
    return &rm.nodes[handle];
}
