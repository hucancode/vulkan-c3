module mj;
import std::collections::list;

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
