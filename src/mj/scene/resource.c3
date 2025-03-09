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

struct ResourceManager {
    List(<Entry>) entries;
    List(<uint>) free_indices;
}

fn Handle ResourceManager.malloc(ResourceManager* this) {
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

fn Type* ResourceManager.get(ResourceManager* this, Handle handle) {
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
