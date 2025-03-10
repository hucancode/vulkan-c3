module mj::resource (<Type>);
import std::collections::list;
import std::core::mem;

bitstruct Handle: uint {
    uint index: 0..23; // lower 24 bits for index, max 8_388_608 items
    char generation: 24..31; // upper 8 bits for generation, max 256 generations
}

struct Entry {
    char generation;
    bool active;
    Type item;
}

struct ResourcePool {
    List(<Entry>) entries;
    List(<uint>) free_indices;
}

fn Handle ResourcePool.malloc(ResourcePool* this) {
    if (this.free_indices.empty()) {
        uint index = this.entries.size();
        this.entries.push({.generation = 0, .active = true});
        return {index, 0};
    }
    uint index = this.free_indices.pop();
    char gen = this.entries[index].generation + 1;
    this.entries[index].generation = gen;
    this.entries[index].active = true;
    return {index, gen};
}

fn void ResourcePool.free(ResourcePool* this, Handle handle) {
    if (handle.index >= this.entries.size()) {
        return;
    }
    char gen = this.entries[handle.index].generation;
    if (gen != handle.generation) {
        return;
    }
    this.entries[handle.index].active = false;
    this.free_indices.push(handle.index);
}

fn Type* ResourcePool.get(ResourcePool* this, Handle handle) {
    if (handle.index >= this.entries.size()) {
        return null;
    }
    char gen = this.entries[handle.index].generation;
    if (gen != handle.generation) {
        return null;
    }
    if (this.entries[handle.index].generation != gen) {
        return null;
    }
    return &this.entries[handle.index].item;
}

module mj;
import mj::resource;

def StaticMeshPool = ResourcePool(<StaticMesh>);
def SkeletalMeshPool = ResourcePool(<SkeletalMesh>);
def MaterialPool = ResourcePool(<Material>);
def TexturePool = ResourcePool(<Texture>);
def LightPool = ResourcePool(<Light>);
def NodePool = ResourcePool(<Node>);

def StaticMeshHandle = Handle;
def SkeletalMeshHandle = Handle;
def MaterialHandle = Handle;
def TextureHandle = Handle;
def LightHandle = Handle;
def NodeHandle = Handle;

struct ResourceManager {
    StaticMeshPool meshes;
    SkeletalMeshPool skeleton_meshes;
    MaterialPool materials;
    TexturePool textures;
    LightPool lights;
    NodePool nodes;
}

fn MeshHandle ResourceManager.new_mesh(ResourceManager* this) {
    return this.meshes.malloc();
}

fn SkeletalMeshHandle ResourceManager.new_skeleton_mesh(ResourceManager* this) {
    return this.skeleton_meshes.malloc();
}

fn MaterialHandle ResourceManager.new_material(ResourceManager* this) {
    return this.materials.malloc();
}

fn TextureHandle ResourceManager.new_texture(ResourceManager* this) {
    return this.textures.malloc();
}

fn LightHandle ResourceManager.new_light(ResourceManager* this) {
    LightHandle ret = this.lights.malloc();
    Light* light = &this.lights[ret.index].item;
    light.color = {1.0f, 1.0f, 1.0f, 1.0f};
    light.intensity = 1.0f;
    return ret;
}

fn NodeHandle ResourceManager.new_node(ResourceManager* this, NodeType type = NodeType.GROUP) {
    NodeHandle ret = this.nodes.malloc();
    Node* node = &this.nodes[ret.index].item;
    node.transform.scale = {1.0f, 1.0f, 1.0f};
    node.type = type;
    return ret;
}
